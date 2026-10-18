"""Translate the EditForthWin ARM64 armasm kernel into ml64.

This file lives in GrokTools. It reads the ARM64 kernel under EditForthWin
and writes generated ml64 into Forth\\kernel\\x64\\asm. Set EDITFORTHWIN to
point at a different tree.

The x64 image keeps one memory cell per ARM64 register. Real RSP is SP.
Internal bl/ret use that virtual link register. Calls into the C host use
the Windows x64 ABI. kernel_init, kernel_eval, and the three kernel_set
entry points take Windows arguments and return with a hardware ret.
"""

from __future__ import annotations

import os
import re
import sys

ROOT = os.environ.get("EDITFORTHWIN", r"C:\VSCodeProjects\EditForthWin")
SRC = os.path.join(ROOT, "Forth", "kernel", "arm64")
OUT = os.path.join(ROOT, "Forth", "kernel", "x64", "asm")

FILES = [
    "state.asm",
    "emit.asm",
    "boot_begin.asm",
    "prims.asm",
    "prims_k1.asm",
    "prims_k2.asm",
    "prims_k3.asm",
    "sa_print.asm",
    "sa_files.asm",
    "sa_float.asm",
    "prims_dbg.asm",
    "dict.asm",
    "entry.asm",
    "cold.asm",
    "boot_end.asm",
]

C_PROCS = {
    "kernel_init",
    "kernel_eval",
    "kernel_set_emit",
    "kernel_set_key",
    "kernel_set_facility_op",
}

OPCODES = {
    "add", "adds", "sub", "subs", "adc", "sbc", "cmp", "cmn", "tst",
    "and", "ands", "orr", "eor", "bic", "mvn", "neg",
    "mov", "movz", "movk", "lsl", "lsr", "asr",
    "mul", "umulh", "smulh", "msub", "udiv", "sdiv",
    "ldr", "ldrb", "str", "strb", "ldp", "stp",
    "adrp", "adr", "lea",
    "cbz", "cbnz", "tbz", "tbnz", "b", "bl", "br", "blr", "ret",
    "csel", "csneg", "cset", "csetm", "ccmp", "extr",
    "fmov", "fadd", "fsub", "fmul", "fdiv", "fmax", "fmin",
    "fneg", "fabs", "fsqrt", "fcmp", "fcvt", "fcvtzs", "scvtf", "ucvtf",
    "dcb", "dcq", "dcd", "space", "align",
}

INVERT = {
    "eq": "ne", "ne": "eq", "hs": "lo", "cs": "cc", "lo": "hs", "cc": "cs",
    "mi": "pl", "pl": "mi", "vs": "vc", "vc": "vs", "hi": "ls", "ls": "hi",
    "ge": "lt", "lt": "ge", "gt": "le", "le": "gt", "al": "nv", "nv": "al",
}


class AsmError(Exception):
    pass


def strip_comment(line: str) -> str:
    out = []
    quote = None
    for ch in line:
        if quote:
            out.append(ch)
            if ch == quote:
                quote = None
            continue
        if ch == '"':
            quote = ch
            out.append(ch)
            continue
        if ch == ";":
            break
        out.append(ch)
    return "".join(out).strip()


def first_token(line: str) -> tuple[str, str]:
    line = line.strip()
    match = re.match(r"(\S+)(?:\s+(.*))?$", line)
    if not match:
        return "", ""
    return match.group(1), (match.group(2) or "").strip()


def split_commas(text: str, brackets: bool = True) -> list[str]:
    out = []
    buf = []
    depth = 0
    quote = None
    for ch in text:
        if quote:
            buf.append(ch)
            if ch == quote:
                quote = None
            continue
        if ch == '"':
            quote = ch
            buf.append(ch)
            continue
        if brackets and ch == "[":
            depth += 1
        elif brackets and ch == "]" and depth > 0:
            depth -= 1
        if ch == "," and depth == 0:
            out.append("".join(buf).strip())
            buf = []
            continue
        buf.append(ch)
    if buf:
        part = "".join(buf).strip()
        if part:
            out.append(part)
    return [part for part in out if part != ""]


def masm_imm(value: int) -> str:
    if value < 0:
        return str(value)
    if value <= 9:
        return str(value)
    hex_digits = format(value & ((1 << 64) - 1), "X")
    if hex_digits[0] in "ABCDEF":
        hex_digits = "0" + hex_digits
    return hex_digits + "h"


def fits_i32(value: int) -> bool:
    return -2147483648 <= value <= 2147483647


def eval_expr(text: str, equ: dict[str, int]):
    expr = (text.replace(":OR:", "|").replace(":AND:", "&")
            .replace(":SHL:", "<<").replace(":SHR:", ">>")
            .replace(":NOT:", "~").replace(":MOD:", "%"))

    def repl(match: re.Match[str]) -> str:
        name = match.group(0)
        if name not in equ:
            raise AsmError(f"unknown symbol in expression: {name}")
        return str(equ[name])

    expr = re.sub(r"(?<![A-Za-z0-9_])[A-Za-z_][A-Za-z0-9_]*", repl, expr)
    if not re.fullmatch(r"[0-9A-Fa-fXx+\-*/<>=|&~() \t]+", expr):
        raise AsmError(f"bad expression: {text}")
    return eval(expr, {"__builtins__": {}}, {})


def area_kind(line: str) -> str:
    match = re.search(r"\|([^|]+)\|", line)
    name = match.group(1).lower() if match else ".text"
    if name in (".text", "text"):
        return "text"
    if name in (".data", "data"):
        return "data"
    if name in (".rdata", "rdata"):
        return "const"
    if name in (".bss", "bss"):
        return "bss"
    if "bootptr" in name:
        return "bootptr"
    if "bootword" in name:
        return "bootword"
    if "bwstr" in name:
        return "bwstr"
    raise AsmError(f"unknown area: {line}")


def is_opcode(token: str) -> bool:
    low = token.lower()
    return low in OPCODES or low.startswith("b.")


class Expander:
    def __init__(self, root: str):
        self.root = root
        self.macros: dict[str, tuple[list[str], list[str]]] = {}
        self.equ: dict[str, int] = {}
        self.lines: list[tuple[str, str]] = []
        self.mode = ["run"]
        self.defining: list[str] | None = None
        self.proto: tuple[str, list[str]] | None = None
        self.expect_proto = False
        self.depth = 0
        self.origin = ""

    def read_lines(self, path: str) -> list[str]:
        with open(path, "r", encoding="utf-8", errors="replace") as handle:
            return handle.read().splitlines()

    def expand_file(self, name: str) -> tuple[list[tuple[str, str]], dict[str, int]]:
        self.macros = {}
        self.equ = {}
        self.lines = []
        self.mode = ["run"]
        self.defining = None
        self.proto = None
        self.expect_proto = False
        self.depth = 0
        self.process_file(os.path.join(self.root, name))
        return self.lines, dict(self.equ)

    def process_file(self, path: str) -> None:
        old = self.origin
        self.origin = path
        for raw in self.read_lines(path):
            if self.process_line(strip_comment(raw)) == "end":
                self.origin = old
                return
        self.origin = old

    def process_line(self, line: str) -> str | None:
        if not line:
            return None
        if self.expect_proto:
            name, rest = first_token(line)
            params = []
            if rest:
                params = [part.strip().lstrip("$") for part in split_commas(rest, False)]
            elif name.startswith("$"):
                params = [name.lstrip("$")]
                name = ""
            if not name or name.startswith("$"):
                raise AsmError(f"bad macro prototype: {line}")
            self.proto = (name, params)
            self.defining = []
            self.expect_proto = False
            return None
        if self.defining is not None:
            if line.upper() == "MEND":
                name, params = self.proto
                self.macros[name] = (params, self.defining)
                self.defining = None
                self.proto = None
            else:
                self.defining.append(line)
            return None

        token, rest = first_token(line)
        upper = token.upper()
        if upper == "MACRO":
            self.expect_proto = True
            return None
        if upper == "IF":
            self.do_if(rest)
            return None
        if upper == "ELSE":
            self.do_else()
            return None
        if upper == "ENDIF":
            self.do_endif()
            return None
        if self.mode[-1] != "run":
            return None
        if upper == "INCLUDE":
            inc = rest.strip().strip('"')
            self.process_file(os.path.join(self.root, inc) if not os.path.isabs(inc)
                              else inc)
            if not os.path.isfile(os.path.join(ROOT, inc)) and not os.path.isfile(
                    os.path.join(self.root, inc)):
                pass
            return None
        if upper == "END":
            return "end"
        if upper == "ENDP":
            self.lines.append((line, self.origin))
            return None
        second, _ = first_token(rest) if rest else ("", "")
        if second.upper() == "EQU":
            _, rhs = first_token(rest)
            self.equ[token] = int(eval_expr(rhs, self.equ))
            return None
        if token in self.macros:
            self.invoke(token, rest, line)
            return None
        self.lines.append((line, self.origin))
        return None

    def do_if(self, expr: str) -> None:
        if self.mode[-1] != "run":
            self.mode.append("skip")
            return
        value = eval_expr(expr, self.equ)
        self.mode.append("run" if value else "skip")

    def do_else(self) -> None:
        if len(self.mode) < 2:
            raise AsmError("ELSE without IF")
        parent = self.mode[-2]
        if parent != "run":
            return
        self.mode[-1] = "skip" if self.mode[-1] == "run" else "run"

    def do_endif(self) -> None:
        if len(self.mode) < 2:
            raise AsmError("ENDIF without IF")
        self.mode.pop()

    def invoke(self, name: str, rest: str, line: str) -> None:
        params, body = self.macros[name]
        args = split_commas(rest, False) if rest else []
        if len(args) != len(params):
            raise AsmError(f"{name} wants {len(params)} args, got {len(args)}: {line}")
        self.depth += 1
        if self.depth > 30:
            raise AsmError(f"macro recursion at {line}")
        pairs = sorted(zip(params, args), key=lambda item: len(item[0]), reverse=True)
        for body_line in body:
            text = body_line
            for param, arg in pairs:
                text = text.replace("$" + param, arg)
            self.process_line(text.strip())
        self.depth -= 1


def scan_labels(lines: list[tuple[str, str]], local: set[str],
                everywhere: set[str], sections: dict[str, str]) -> None:
    section = "text"
    for text, _origin in lines:
        token, rest = first_token(text)
        upper = token.upper()
        if upper == "AREA":
            section = area_kind(text)
            continue
        if is_opcode(token) or upper in ("EXPORT", "EXTERN", "INCBIN", "ENDP", "ALIGN"):
            continue
        if rest:
            second, _ = first_token(rest)
            if second.upper() == "EQU":
                continue
        local.add(token)
        everywhere.add(token)
        sections.setdefault(token, section)


class Translator:
    def __init__(self, equ: dict[str, int], local: set[str], everywhere: set[str],
                 sections: dict[str, str], origin_name: str):
        self.equ = equ
        self.local = local
        self.everywhere = everywhere
        self.sections = sections
        self.origin_name = origin_name
        self.body: list[str] = []
        self.externs: set[str] = set()
        self.section = ""
        self.proc_stack: list[bool] = []
        self.nid = 0
        self.c_calls: set[str] = set()

    def lab(self, prefix: str) -> str:
        self.nid += 1
        return f"x{prefix}_{self.nid}"

    def L(self, text: str) -> None:
        self.body.append("    " + text)

    def use_sym(self, name: str) -> None:
        if name in self.local or name.startswith("xret_") or name.startswith("xsk_"):
            return
        self.externs.add(name)
        if name not in self.everywhere:
            self.c_calls.add(name)

    def set_section(self, kind: str) -> None:
        if kind == self.section:
            return
        if self.section in ("bootptr", "bootword", "bwstr"):
            self.body.append(self.section.upper() + " ENDS")
        self.section = kind
        if kind == "text":
            self.body.append(".CODE")
        elif kind == "data":
            self.body.append(".DATA")
        elif kind == "const":
            self.body.append(".CONST")
        elif kind == "bss":
            self.body.append(".DATA?")
        elif kind == "bootptr":
            self.body.append("BOOTPTR SEGMENT ALIGN(8) READ")
        elif kind == "bootword":
            self.body.append("BOOTWORD SEGMENT ALIGN(8) READ")
        elif kind == "bwstr":
            self.body.append("BWSTR SEGMENT ALIGN(1) READ")
        else:
            raise AsmError(kind)

    def close_section(self) -> None:
        if self.section in ("bootptr", "bootword", "bwstr"):
            self.body.append(self.section.upper() + " ENDS")
            self.section = ""

    def translate(self, lines: list[tuple[str, str]]) -> str:
        for text, _origin in lines:
            try:
                self.translate_line(text)
            except AsmError as exc:
                raise AsmError(f"{self.origin_name}: {exc} | {text}") from exc
        self.close_section()
        header = [
            f"; Generated from Forth/kernel/arm64/{self.origin_name}. Do not edit.",
            "OPTION CASEMAP:NONE",
        ]
        for index in range(31):
            header.append(f"EXTRN arm_x{index}:QWORD")
        for name in ("arm_n", "arm_z", "arm_c", "arm_v"):
            header.append(f"EXTRN {name}:BYTE")
        for name in sorted(self.externs):
            if name in self.everywhere and self.sections.get(name) != "text":
                kind = "BYTE"
            else:
                kind = "PROC"
            header.append(f"EXTRN {name}:{kind}")
        return "\r\n".join(header + self.body + ["END", ""])

    def translate_line(self, line: str) -> None:
        token, rest = first_token(line)
        upper = token.upper()
        if upper == "AREA":
            self.set_section(area_kind(line))
            return
        if upper == "EXPORT":
            self.body.append("PUBLIC " + rest.split()[0])
            return
        if upper == "EXTERN":
            return
        if upper == "INCBIN":
            self.emit_incbin(rest.strip().strip('"'))
            return
        if upper == "ENDP":
            if self.proc_stack:
                self.proc_stack.pop()
            return
        if is_opcode(token):
            self.translate_op(token.lower(), rest, line)
            return
        if not rest:
            self.body.append(token + ":")
            return
        second, _ = first_token(rest)
        if second.upper() == "PROC":
            self.on_proc(token)
            return
        self.body.append(token + ":")
        self.translate_line(rest)

    def on_proc(self, name: str) -> None:
        self.body.append(name + ":")
        hardware = name in C_PROCS
        self.proc_stack.append(hardware)
        if hardware:
            self.L("mov QWORD PTR arm_x0, rcx")
            self.L("mov QWORD PTR arm_x1, rdx")
            self.L("mov QWORD PTR arm_x2, r8")
            self.L("mov QWORD PTR arm_x3, r9")

    def emit_incbin(self, rel: str) -> None:
        path = rel if os.path.isabs(rel) else os.path.join(ROOT, rel.replace("/", os.sep))
        with open(path, "rb") as handle:
            data = handle.read()
        self.body.append(f"    ; INCBIN {rel} ({len(data)} bytes)")
        for offset in range(0, len(data), 16):
            chunk = data[offset:offset + 16]
            nums = ", ".join(f"0{byte:02X}h" for byte in chunk)
            self.body.append("    DB " + nums)

    def translate_op(self, op: str, rest: str, line: str) -> None:
        if len(line) < 140:
            safe = line.replace("\t", " ")
            self.body.append("    ; " + safe)
        ops = self.normalize(split_commas(rest) if rest else [])
        if op == "align":
            self.body.append("ALIGN " + ops[0])
            return
        if op == "space":
            count = self.number(ops[0])
            fill = "?" if self.section == "bss" else "0"
            self.body.append(f"    DB {count} DUP({fill})")
            return
        if op == "dcb":
            self.emit_dcb(ops)
            return
        if op == "dcq":
            self.emit_dc(ops, "DQ")
            return
        if op == "dcd":
            self.emit_dc(ops, "DD")
            return
        if op == "lea":
            self.emit_lea(ops)
            return
        if op == "adrp":
            raise AsmError("unpaired adrp")
        if op == "ret":
            self.emit_ret()
            return
        if op == "b" or op.startswith("b."):
            cond = "al" if op == "b" else op[2:]
            self.use_label(ops[0])
            if cond == "al":
                self.L("jmp " + ops[0])
            else:
                self.jcc(cond, ops[0])
            return
        if op == "bl":
            self.emit_bl(ops[0])
            return
        if op == "br":
            self.load(self.parse_op(ops[0]), "rax", 64)
            self.L("jmp rax")
            return
        if op == "blr":
            self.emit_ccall(arm=self.parse_op(ops[0]))
            return
        if op in ("cbz", "cbnz"):
            self.emit_cbz(op, ops)
            return
        if op in ("tbz", "tbnz"):
            self.emit_tbz(op, ops)
            return
        if op == "mov":
            self.emit_mov(ops)
            return
        if op in ("movz", "movk"):
            self.emit_movk(op, ops)
            return
        if op in ("add", "adds", "sub", "subs", "and", "ands", "orr", "eor"):
            self.emit_binop(op, ops)
            return
        if op in ("adc", "sbc"):
            self.emit_adc(op, ops)
            return
        if op in ("cmp", "cmn", "tst"):
            self.emit_cmp(op, ops)
            return
        if op == "bic":
            self.emit_bic(ops)
            return
        if op in ("mvn", "neg"):
            self.emit_unary(op, ops)
            return
        if op in ("lsl", "lsr", "asr"):
            self.emit_shift(op, ops)
            return
        if op == "mul":
            self.emit_mul(ops)
            return
        if op in ("umulh", "smulh"):
            self.emit_mulh(op, ops)
            return
        if op == "msub":
            self.emit_msub(ops)
            return
        if op in ("udiv", "sdiv"):
            self.emit_div(op, ops)
            return
        if op in ("ldr", "ldrb", "str", "strb"):
            self.emit_mem(op, ops)
            return
        if op in ("ldp", "stp"):
            self.emit_pair(op, ops)
            return
        if op in ("csel", "csneg", "cset", "csetm"):
            self.emit_cset(op, ops)
            return
        if op == "ccmp":
            self.emit_ccmp(ops)
            return
        if op == "extr":
            self.emit_extr(ops)
            return
        if op == "adr":
            self.emit_adr(ops)
            return
        if op in ("fmov", "fadd", "fsub", "fmul", "fdiv", "fmax", "fmin",
                  "fneg", "fabs", "fsqrt", "fcmp", "fcvt", "fcvtzs", "scvtf", "ucvtf"):
            self.emit_fp(op, ops)
            return
        raise AsmError("unhandled " + op)

    def normalize(self, ops: list[str]) -> list[str]:
        merged = []
        index = 0
        while index < len(ops):
            if index + 1 < len(ops) and re.match(r"(?i)^(lsl|lsr|asr)\s+#", ops[index + 1]):
                merged.append(ops[index] + " " + ops[index + 1])
                index += 2
                continue
            merged.append(ops[index])
            index += 1
        out = []
        index = 0
        while index < len(merged):
            item = merged[index]
            if (index + 1 < len(merged) and item.startswith("[") and item.endswith("]")
                    and re.fullmatch(r"#-?(?:0x)?[0-9A-Fa-f]+", merged[index + 1])):
                out.append(item + "," + merged[index + 1])
                index += 2
                continue
            out.append(item)
            index += 1
        return out

    def number(self, text: str) -> int:
        token = text.strip()
        if token.startswith("#"):
            token = token[1:].strip()
        if token in self.equ:
            return self.equ[token]
        if re.fullmatch(r"-?(?:0x[0-9A-Fa-f]+|\d+)", token):
            return int(token, 0)
        char = re.fullmatch(r"'(.)'", token)
        if char:
            return ord(char.group(1))
        raise AsmError(f"not a number: {text}")

    def parse_op(self, text: str):
        shift = None
        body = text.strip()
        match = re.fullmatch(r"(.+?)\s+(lsl|lsr|asr)\s+#(-?(?:0x)?[0-9A-Fa-f]+)", body, re.I)
        if match:
            body = match.group(1).strip()
            shift = (match.group(2).lower(), int(match.group(3), 0))
        low = body.lower()
        if low in ("xzr", "wzr"):
            return {"kind": "zr", "width": 32 if low == "wzr" else 64, "shift": shift}
        if low == "sp":
            return {"kind": "sp", "width": 64, "shift": shift}
        reg = re.fullmatch(r"([xw])(\d+)", low)
        if reg:
            return {"kind": "reg", "num": int(reg.group(2)), "width": 32 if reg.group(1) == "w" else 64,
                    "shift": shift}
        freg = re.fullmatch(r"([ds])(\d+)", low)
        if freg:
            return {"kind": "freg", "num": int(freg.group(2)), "width": 64 if freg.group(1) == "d" else 32,
                    "shift": shift}
        if body.startswith("[") or body.startswith('"') or body.startswith("'"):
            return {"kind": "raw", "text": text}
        value = self.number(body)
        if shift:
            kind, count = shift
            if kind == "lsl":
                value <<= count
            elif kind == "lsr":
                value = (value & ((1 << 64) - 1)) >> count
            else:
                raise AsmError("asr immediate")
            shift = None
        return {"kind": "imm", "value": value, "width": 64, "shift": shift}

    def parse_mem(self, text: str) -> dict:
        pre = text.endswith("!")
        body = text[:-1] if pre else text
        post = None
        match = re.fullmatch(r"\[(.*)\](?:,#(-?(?:0x)?[0-9A-Fa-f]+))?", body)
        if not match:
            raise AsmError(f"bad address: {text}")
        if match.group(2) is not None:
            post = int(match.group(2), 0)
        inner = split_commas(match.group(1))
        base = inner[0].lower()
        disp = 0
        index = None
        sh = 0
        if len(inner) >= 2:
            if inner[1].startswith("#"):
                disp = self.number(inner[1])
            else:
                index = self.parse_op(inner[1])
                if len(inner) >= 3:
                    shift = re.fullmatch(r"(?i)lsl\s*#\s*(-?(?:0x)?[0-9A-Fa-f]+)", inner[2])
                    if not shift:
                        raise AsmError(f"bad index shift: {text}")
                    sh = int(shift.group(1), 0)
        return {"base": base, "disp": disp, "index": index, "shift": sh, "pre": pre, "post": post}

    def reg_mem(self, operand: dict) -> str:
        return f"arm_x{operand['num']}"

    def load(self, operand: dict, dest: str, width: int) -> None:
        piece = {"rax": "eax", "rcx": "ecx", "r11": "r11d"}.get(dest, dest)
        use32 = width == 32 or operand.get("width") == 32
        if operand["kind"] == "imm":
            if use32:
                self.L(f"mov {piece}, {masm_imm(operand['value'])}")
            else:
                self.L(f"mov {dest}, {masm_imm(operand['value'])}")
            return
        if operand["kind"] == "zr":
            self.L(f"xor {piece}, {piece}")
            return
        if operand["kind"] == "sp":
            self.L(f"mov {dest}, rsp")
            return
        mem = self.reg_mem(operand)
        if use32:
            self.L(f"mov {piece}, DWORD PTR {mem}")
        else:
            self.L(f"mov {dest}, QWORD PTR {mem}")
        if operand.get("shift"):
            kind, count = operand["shift"]
            ins = {"lsl": "shl", "lsr": "shr", "asr": "sar"}[kind]
            reg = piece if use32 else dest
            self.L(f"{ins} {reg}, {count}")

    def store(self, operand: dict, src: str = "rax") -> None:
        if operand["kind"] == "zr":
            return
        if operand["kind"] == "sp":
            self.L(f"mov rsp, {src}")
            return
        self.L(f"mov QWORD PTR {self.reg_mem(operand)}, {src}")

    def add_base(self, base: str, disp: int) -> None:
        if disp == 0:
            return
        if base == "sp":
            self.L(f"add rsp, {masm_imm(disp)}")
            return
        num = int(base[1:])
        self.L(f"mov rax, QWORD PTR arm_x{num}")
        self.L(f"add rax, {masm_imm(disp)}")
        self.L(f"mov QWORD PTR arm_x{num}, rax")

    def emit_ea(self, mem: dict) -> int | None:
        base = mem["base"]
        if mem["pre"]:
            self.add_base(base, mem["disp"])
            if base == "sp":
                self.L("lea r10, [rsp]")
            else:
                self.L(f"mov r10, QWORD PTR arm_x{int(base[1:])}")
            return mem["post"]
        if base == "sp":
            self.L("lea r10, [rsp]")
        else:
            self.L(f"mov r10, QWORD PTR arm_x{int(base[1:])}")
        if mem["index"] is not None:
            self.load(mem["index"], "rax", 64)
            if mem["shift"]:
                self.L(f"shl rax, {mem['shift']}")
            self.L("add r10, rax")
        if mem["disp"]:
            self.L(f"add r10, {masm_imm(mem['disp'])}")
        return mem["post"]

    def snap(self, carry: str) -> None:
        self.L("seto BYTE PTR arm_v")
        self.L("sets BYTE PTR arm_n")
        self.L("setz BYTE PTR arm_z")
        if carry == "invert":
            self.L("setnc BYTE PTR arm_c")
        else:
            self.L("setc BYTE PTR arm_c")

    def jcc(self, cond: str, target: str) -> None:
        cond = cond.lower()
        if cond in ("eq",):
            self.L("cmp BYTE PTR arm_z, 0")
            self.L(f"jne {target}")
        elif cond in ("ne",):
            self.L("cmp BYTE PTR arm_z, 0")
            self.L(f"je {target}")
        elif cond in ("hs", "cs"):
            self.L("cmp BYTE PTR arm_c, 0")
            self.L(f"jne {target}")
        elif cond in ("lo", "cc"):
            self.L("cmp BYTE PTR arm_c, 0")
            self.L(f"je {target}")
        elif cond in ("mi",):
            self.L("cmp BYTE PTR arm_n, 0")
            self.L(f"jne {target}")
        elif cond in ("pl",):
            self.L("cmp BYTE PTR arm_n, 0")
            self.L(f"je {target}")
        elif cond in ("vs",):
            self.L("cmp BYTE PTR arm_v, 0")
            self.L(f"jne {target}")
        elif cond in ("vc",):
            self.L("cmp BYTE PTR arm_v, 0")
            self.L(f"je {target}")
        elif cond == "hi":
            skip = self.lab("sk")
            self.L("cmp BYTE PTR arm_c, 0")
            self.L(f"je {skip}")
            self.L("cmp BYTE PTR arm_z, 0")
            self.L(f"je {target}")
            self.L(f"{skip}:")
        elif cond == "ls":
            self.L("cmp BYTE PTR arm_c, 0")
            self.L(f"je {target}")
            self.L("cmp BYTE PTR arm_z, 0")
            self.L(f"jne {target}")
        elif cond == "ge":
            self.L("mov r11b, BYTE PTR arm_n")
            self.L("cmp r11b, BYTE PTR arm_v")
            self.L(f"je {target}")
        elif cond == "lt":
            self.L("mov r11b, BYTE PTR arm_n")
            self.L("cmp r11b, BYTE PTR arm_v")
            self.L(f"jne {target}")
        elif cond == "gt":
            skip = self.lab("sk")
            self.L("cmp BYTE PTR arm_z, 0")
            self.L(f"jne {skip}")
            self.L("mov r11b, BYTE PTR arm_n")
            self.L("cmp r11b, BYTE PTR arm_v")
            self.L(f"je {target}")
            self.L(f"{skip}:")
        elif cond == "le":
            self.L("cmp BYTE PTR arm_z, 0")
            self.L(f"jne {target}")
            self.L("mov r11b, BYTE PTR arm_n")
            self.L("cmp r11b, BYTE PTR arm_v")
            self.L(f"jne {target}")
        elif cond == "al":
            self.L(f"jmp {target}")
        elif cond == "nv":
            return
        else:
            raise AsmError("bad condition " + cond)

    def use_label(self, name: str) -> None:
        if name not in self.local:
            self.use_sym(name)

    def emit_ret(self) -> None:
        if self.proc_stack and self.proc_stack[-1]:
            self.L("mov rax, QWORD PTR arm_x0")
            self.L("ret")
        else:
            self.L("jmp QWORD PTR arm_x30")

    def emit_bl(self, target: str) -> None:
        if target in self.everywhere:
            ret = self.lab("ret")
            self.L(f"lea rax, {ret}")
            self.L("mov QWORD PTR arm_x30, rax")
            self.use_label(target)
            self.L(f"jmp {target}")
            self.L(f"{ret}:")
            return
        self.use_sym(target)
        self.c_calls.add(target)
        self.emit_ccall(symbol=target)

    def emit_ccall(self, symbol: str | None = None, arm: dict | None = None) -> None:
        self.L("push rbx")
        self.L("mov rbx, rsp")
        self.L("and rsp, -16")
        self.L("sub rsp, 80")
        self.L("mov rcx, QWORD PTR arm_x0")
        self.L("mov rdx, QWORD PTR arm_x1")
        self.L("mov r8, QWORD PTR arm_x2")
        self.L("mov r9, QWORD PTR arm_x3")
        for reg, slot in ((4, 32), (5, 40), (6, 48), (7, 56)):
            self.L(f"mov rax, QWORD PTR arm_x{reg}")
            self.L(f"mov QWORD PTR [rsp+{slot}], rax")
        # ARM64 keeps the 9th integer arg at [sp]. File ops pass o3* there.
        self.L("mov rax, QWORD PTR [rbx+8]")
        self.L("mov QWORD PTR [rsp+64], rax")
        if arm is not None:
            self.load(arm, "r11", 64)
            self.L("call r11")
        else:
            self.L(f"call {symbol}")
        self.L("mov QWORD PTR arm_x0, rax")
        self.L("mov rsp, rbx")
        self.L("pop rbx")

    def emit_lea(self, ops: list[str]) -> None:
        dest = self.parse_op(ops[0])
        symbol = ops[1]
        self.use_sym(symbol)
        self.L(f"lea rax, {symbol}")
        self.store(dest)

    def emit_cbz(self, op: str, ops: list[str]) -> None:
        src = self.parse_op(ops[0])
        self.use_label(ops[1])
        self.load(src, "rax", src["width"])
        self.L("cmp rax, 0")
        self.L(("je " if op == "cbz" else "jne ") + ops[1])

    def emit_tbz(self, op: str, ops: list[str]) -> None:
        src = self.parse_op(ops[0])
        bit = self.number(ops[1])
        self.use_label(ops[2])
        self.load(src, "rax", src["width"])
        self.L(f"bt rax, {bit}")
        self.L(("jnc " if op == "tbz" else "jc ") + ops[2])

    def emit_mov(self, ops: list[str]) -> None:
        dest = self.parse_op(ops[0])
        src = self.parse_op(ops[1])
        width = 32 if dest["width"] == 32 else 64
        self.load(src, "rax", width)
        self.store(dest)

    def emit_movk(self, op: str, ops: list[str]) -> None:
        dest = self.parse_op(ops[0])
        # parse_op folds lsl into the immediate and drops the shift, which
        # turns movk #imm, lsl #n into a zero field. Read the raw operand.
        raw = ops[1].strip()
        shifted = re.fullmatch(
            r"#?\s*(.+?)\s+(?:lsl|lsr|asr)\s+#(-?(?:0x)?[0-9A-Fa-f]+)", raw, re.I)
        if shifted:
            value = self.number(shifted.group(1)) & 0xFFFF
            shift = int(shifted.group(2), 0)
        else:
            value = self.number(raw) & 0xFFFF
            shift = 0
        field = (value << shift) & ((1 << 64) - 1)
        if op == "movz":
            self.L(f"mov rax, {masm_imm(field)}")
            self.store(dest)
            return
        mask = (~(0xFFFF << shift)) & ((1 << 64) - 1)
        self.load(dest, "rax", 64)
        self.L(f"mov rcx, {masm_imm(mask)}")
        self.L("and rax, rcx")
        self.L(f"mov rcx, {masm_imm(field)}")
        self.L("or rax, rcx")
        self.store(dest)

    def width_of(self, operand: dict) -> int:
        return 32 if operand.get("width") == 32 else 64

    def apply_src(self, insn: str, src: dict, width: int) -> None:
        reg = "eax" if width == 32 else "rax"
        if src["kind"] == "imm" and not src.get("shift"):
            if fits_i32(src["value"]):
                self.L(f"{insn} {reg}, {masm_imm(src['value'])}")
            else:
                self.L(f"mov r8, {masm_imm(src['value'])}")
                self.L(f"{insn} {reg}, r8")
            return
        self.load(src, "rcx", width)
        other = "ecx" if width == 32 else "rcx"
        self.L(f"{insn} {reg}, {other}")

    def emit_binop(self, op: str, ops: list[str]) -> None:
        dest = self.parse_op(ops[0])
        src1 = self.parse_op(ops[1])
        src2 = self.parse_op(ops[2])
        width = 32 if dest["width"] == 32 else 64
        mapping = {"add": "add", "adds": "add", "sub": "sub", "subs": "sub",
                   "and": "and", "ands": "and", "orr": "or", "eor": "xor"}
        self.load(src1, "rax", width)
        self.apply_src(mapping[op], src2, width)
        if op in ("adds", "subs"):
            self.snap("same" if op == "adds" else "invert")
        elif op == "ands":
            self.snap("same")
        self.store(dest)

    def emit_adc(self, op: str, ops: list[str]) -> None:
        dest = self.parse_op(ops[0])
        src1 = self.parse_op(ops[1])
        src2 = self.parse_op(ops[2])
        width = 32 if dest["width"] == 32 else 64
        self.load(src1, "rax", width)
        self.load(src2, "rcx", width)
        self.L("mov dl, BYTE PTR arm_c")
        if op == "sbc":
            self.L("xor dl, 1")
        self.L("add dl, 255")
        reg = "eax" if width == 32 else "rax"
        other = "ecx" if width == 32 else "rcx"
        self.L(("sbb " if op == "sbc" else "adc ") + f"{reg}, {other}")
        self.store(dest)

    def emit_cmp(self, op: str, ops: list[str]) -> None:
        src1 = self.parse_op(ops[0])
        src2 = self.parse_op(ops[1])
        width = src1["width"]
        self.load(src1, "rax", width)
        ins = {"cmp": "cmp", "cmn": "add", "tst": "test"}[op]
        self.apply_src(ins, src2, width)
        self.snap("invert" if op == "cmp" else "same")

    def emit_bic(self, ops: list[str]) -> None:
        dest = self.parse_op(ops[0])
        src1 = self.parse_op(ops[1])
        src2 = self.parse_op(ops[2])
        width = 32 if dest["width"] == 32 else 64
        self.load(src1, "rax", width)
        self.load(src2, "rcx", width)
        other = "ecx" if width == 32 else "rcx"
        reg = "eax" if width == 32 else "rax"
        self.L(f"not {other}")
        self.L(f"and {reg}, {other}")
        self.store(dest)

    def emit_unary(self, op: str, ops: list[str]) -> None:
        dest = self.parse_op(ops[0])
        src = self.parse_op(ops[1])
        width = 32 if dest["width"] == 32 else 64
        self.load(src, "rax", width)
        reg = "eax" if width == 32 else "rax"
        self.L(("not " if op == "mvn" else "neg ") + reg)
        self.store(dest)

    def emit_shift(self, op: str, ops: list[str]) -> None:
        dest = self.parse_op(ops[0])
        src = self.parse_op(ops[1])
        count = self.parse_op(ops[2])
        width = 32 if dest["width"] == 32 else 64
        ins = {"lsl": "shl", "lsr": "shr", "asr": "sar"}[op]
        self.load(src, "rax", width)
        reg = "eax" if width == 32 else "rax"
        if count["kind"] == "imm":
            self.L(f"{ins} {reg}, {count['value'] & 63}")
        else:
            self.load(count, "rcx", 64)
            self.L(f"{ins} {reg}, cl")
        self.store(dest)

    def emit_mul(self, ops: list[str]) -> None:
        dest = self.parse_op(ops[0])
        self.load(self.parse_op(ops[1]), "rax", 64)
        self.load(self.parse_op(ops[2]), "rcx", 64)
        self.L("imul rax, rcx")
        self.store(dest)

    def emit_mulh(self, op: str, ops: list[str]) -> None:
        dest = self.parse_op(ops[0])
        self.load(self.parse_op(ops[1]), "rax", 64)
        self.load(self.parse_op(ops[2]), "rcx", 64)
        if op == "umulh":
            self.L("mul rcx")
        else:
            self.L("imul rcx")
        self.L("mov rax, rdx")
        self.store(dest)

    def emit_msub(self, ops: list[str]) -> None:
        dest = self.parse_op(ops[0])
        self.load(self.parse_op(ops[1]), "rax", 64)
        self.load(self.parse_op(ops[2]), "rcx", 64)
        self.L("imul rax, rcx")
        self.load(self.parse_op(ops[3]), "rcx", 64)
        self.L("sub rcx, rax")
        self.L("mov rax, rcx")
        self.store(dest)

    def emit_div(self, op: str, ops: list[str]) -> None:
        dest = self.parse_op(ops[0])
        self.load(self.parse_op(ops[1]), "rax", 64)
        self.load(self.parse_op(ops[2]), "rcx", 64)
        done = self.lab("div")
        zero = self.lab("div0")
        self.L("cmp rcx, 0")
        self.L(f"je {zero}")
        if op == "sdiv":
            ovf = self.lab("divov")
            self.L("cmp rcx, -1")
            self.L(f"jne {ovf}")
            self.L("mov r8, 8000000000000000h")
            self.L("cmp rax, r8")
            self.L(f"je {done}")
            self.L(f"{ovf}:")
            self.L("cqo")
            self.L("idiv rcx")
        else:
            self.L("xor rdx, rdx")
            self.L("div rcx")
        self.L(f"jmp {done}")
        self.L(f"{zero}:")
        self.L("xor eax, eax")
        self.L(f"{done}:")
        self.store(dest)

    def emit_mem(self, op: str, ops: list[str]) -> None:
        reg = self.parse_op(ops[0])
        mem = self.parse_mem(ops[1])
        post = self.emit_ea(mem)
        if op in ("str", "strb"):
            if reg["kind"] == "freg":
                mov = "movss" if reg["width"] == 32 else "movsd"
                ptr = "DWORD" if reg["width"] == 32 else "QWORD"
                self.L(f"{mov} {ptr} PTR [r10], {self.xmm(reg)}")
                if post:
                    self.add_base(mem["base"], post)
                return
            size = 1 if op == "strb" else (4 if reg["width"] == 32 else 8)
            if reg["kind"] == "zr":
                ptr = {8: "QWORD", 4: "DWORD", 1: "BYTE"}[size]
                self.L(f"mov {ptr} PTR [r10], 0")
            else:
                self.load(reg, "rax", 32 if size != 8 else 64)
                if size == 8:
                    self.L("mov QWORD PTR [r10], rax")
                elif size == 4:
                    self.L("mov DWORD PTR [r10], eax")
                else:
                    self.L("mov BYTE PTR [r10], al")
        else:
            if reg["kind"] == "freg":
                mov = "movss" if reg["width"] == 32 else "movsd"
                ptr = "DWORD" if reg["width"] == 32 else "QWORD"
                self.L(f"{mov} {self.xmm(reg)}, {ptr} PTR [r10]")
                if post:
                    self.add_base(mem["base"], post)
                return
            size = 1 if op == "ldrb" else (4 if reg["width"] == 32 else 8)
            if size == 8:
                self.L("mov rax, QWORD PTR [r10]")
            elif size == 4:
                self.L("mov eax, DWORD PTR [r10]")
            else:
                self.L("movzx eax, BYTE PTR [r10]")
            self.store(reg)
        if post:
            self.add_base(mem["base"], post)

    def emit_pair(self, op: str, ops: list[str]) -> None:
        a = self.parse_op(ops[0])
        b = self.parse_op(ops[1])
        mem = self.parse_mem(ops[2])
        post = self.emit_ea(mem)
        if op == "stp":
            self.store_pair_src(a, 0)
            self.store_pair_src(b, 8)
        else:
            self.L("mov rax, QWORD PTR [r10]")
            self.L("mov rcx, QWORD PTR [r10+8]")
            self.store(a, "rax")
            self.store(b, "rcx")
        if post:
            self.add_base(mem["base"], post)

    def store_pair_src(self, operand: dict, disp: int) -> None:
        if operand["kind"] == "zr":
            self.L(f"mov QWORD PTR [r10+{disp}], 0")
            return
        self.load(operand, "rax", 64)
        self.L(f"mov QWORD PTR [r10+{disp}], rax")

    def emit_cset(self, op: str, ops: list[str]) -> None:
        if op in ("cset", "csetm"):
            dest = self.parse_op(ops[0])
            cond = ops[1]
            false_lab = self.lab("sk")
            self.L("xor eax, eax")
            self.jcc(INVERT[cond.lower()], false_lab)
            if op == "cset":
                self.L("mov eax, 1")
            else:
                self.L("mov rax, -1")
            self.L(f"{false_lab}:")
            self.store(dest)
            return
        dest = self.parse_op(ops[0])
        yes = self.parse_op(ops[1])
        no = self.parse_op(ops[2])
        cond = ops[3]
        taken = self.lab("sk")
        done = self.lab("sk")
        self.jcc(cond, taken)
        self.load(no, "rax", 64)
        if op == "csneg":
            self.L("neg rax")
        self.L(f"jmp {done}")
        self.L(f"{taken}:")
        self.load(yes, "rax", 64)
        self.L(f"{done}:")
        self.store(dest)

    def emit_ccmp(self, ops: list[str]) -> None:
        src1 = self.parse_op(ops[0])
        src2 = self.parse_op(ops[1])
        nzcv = self.number(ops[2])
        cond = ops[3]
        compare = self.lab("sk")
        done = self.lab("sk")
        self.jcc(cond, compare)
        self.L(f"mov BYTE PTR arm_n, {(nzcv >> 3) & 1}")
        self.L(f"mov BYTE PTR arm_z, {(nzcv >> 2) & 1}")
        self.L(f"mov BYTE PTR arm_c, {(nzcv >> 1) & 1}")
        self.L(f"mov BYTE PTR arm_v, {nzcv & 1}")
        self.L(f"jmp {done}")
        self.L(f"{compare}:")
        width = src1["width"]
        self.load(src1, "rax", width)
        self.apply_src("cmp", src2, width)
        self.snap("invert")
        self.L(f"{done}:")

    def emit_extr(self, ops: list[str]) -> None:
        dest = self.parse_op(ops[0])
        high = self.parse_op(ops[1])
        low = self.parse_op(ops[2])
        count = self.number(ops[3])
        self.load(low, "rax", 64)
        self.load(high, "rcx", 64)
        self.L("mov rdx, rcx")
        self.L(f"shrd rax, rdx, {count}")
        self.store(dest)

    def xmm(self, operand: dict) -> str:
        return f"xmm{operand['num']}"

    def emit_adr(self, ops: list[str]) -> None:
        dest = self.parse_op(ops[0])
        label = ops[1]
        self.use_label(label)
        self.L(f"lea rax, {label}")
        self.store(dest)

    def movfp(self, dest: dict, src: dict) -> None:
        if dest["num"] == src["num"] and dest["width"] == src["width"]:
            return
        ins = "movss" if dest["width"] == 32 or src["width"] == 32 else "movsd"
        self.L(f"{ins} {self.xmm(dest)}, {self.xmm(src)}")

    def snap_float(self) -> None:
        # ARM FCMP flags from ucomisd: N=less, Z=equal, C=not less, V=unordered.
        self.L("setb al")
        self.L("setp cl")
        self.L("setz dl")
        self.L("mov r11b, al")
        self.L("or r11b, cl")
        self.L("xor r11b, cl")
        self.L("mov BYTE PTR arm_n, r11b")
        self.L("mov r11b, dl")
        self.L("or r11b, cl")
        self.L("xor r11b, cl")
        self.L("mov BYTE PTR arm_z, r11b")
        self.L("mov BYTE PTR arm_v, cl")
        self.L("mov r11b, BYTE PTR arm_n")
        self.L("xor r11b, 1")
        self.L("mov BYTE PTR arm_c, r11b")

    def emit_fp(self, op: str, ops: list[str]) -> None:
        if op == "fcmp":
            left = self.parse_op(ops[0])
            right_text = ops[1].strip()
            if right_text in ("#0.0", "#0", "0.0", "#0.0"):
                self.L("xorpd xmm15, xmm15")
                self.L(f"ucomisd {self.xmm(left)}, xmm15")
            else:
                right = self.parse_op(right_text)
                self.L(f"ucomisd {self.xmm(left)}, {self.xmm(right)}")
            self.snap_float()
            return
        if op == "fmov":
            dest = self.parse_op(ops[0])
            src = self.parse_op(ops[1])
            if dest["kind"] == "freg" and src["kind"] == "freg":
                self.movfp(dest, src)
            elif dest["kind"] == "freg" and src["kind"] == "zr":
                self.L(f"xorpd {self.xmm(dest)}, {self.xmm(dest)}")
            elif dest["kind"] == "freg" and src["kind"] == "reg":
                self.load(src, "rax", 64)
                self.L(f"movq {self.xmm(dest)}, rax")
            elif dest["kind"] == "reg" and src["kind"] == "freg":
                self.L(f"movq rax, {self.xmm(src)}")
                self.store(dest)
            else:
                raise AsmError("bad fmov")
            return
        if op == "fcvt":
            dest = self.parse_op(ops[0])
            src = self.parse_op(ops[1])
            if dest["width"] == 64 and src["width"] == 32:
                self.L(f"cvtss2sd {self.xmm(dest)}, {self.xmm(src)}")
            elif dest["width"] == 32 and src["width"] == 64:
                self.L(f"cvtsd2ss {self.xmm(dest)}, {self.xmm(src)}")
            else:
                self.movfp(dest, src)
            return
        if op == "fcvtzs":
            dest = self.parse_op(ops[0])
            src = self.parse_op(ops[1])
            self.L(f"cvttsd2si rax, {self.xmm(src)}")
            self.store(dest)
            return
        if op in ("scvtf", "ucvtf"):
            dest = self.parse_op(ops[0])
            src = self.parse_op(ops[1])
            self.load(src, "rax", 64)
            self.L(f"cvtsi2sd {self.xmm(dest)}, rax")
            if op == "ucvtf":
                skip = self.lab("ucv")
                self.L("test rax, rax")
                self.L(f"jns {skip}")
                self.L("mov rcx, 43F0000000000000h")
                self.L("movq xmm15, rcx")
                self.L(f"addsd {self.xmm(dest)}, xmm15")
                self.L(f"{skip}:")
            return
        if op in ("fneg", "fabs", "fsqrt"):
            dest = self.parse_op(ops[0])
            src = self.parse_op(ops[1])
            self.movfp(dest, src)
            if op == "fsqrt":
                self.L(f"sqrtsd {self.xmm(dest)}, {self.xmm(dest)}")
            elif op == "fabs":
                self.L("mov rax, 7FFFFFFFFFFFFFFFh")
                self.L("movq xmm15, rax")
                self.L(f"andpd {self.xmm(dest)}, xmm15")
            else:
                self.L("mov rax, 8000000000000000h")
                self.L("movq xmm15, rax")
                self.L(f"xorpd {self.xmm(dest)}, xmm15")
            return
        dest = self.parse_op(ops[0])
        src1 = self.parse_op(ops[1])
        src2 = self.parse_op(ops[2])
        self.movfp(dest, src1)
        ins = {"fadd": "addsd", "fsub": "subsd", "fmul": "mulsd", "fdiv": "divsd",
               "fmax": "maxsd", "fmin": "minsd"}[op]
        self.L(f"{ins} {self.xmm(dest)}, {self.xmm(src2)}")

    def emit_dcb(self, ops: list[str]) -> None:
        parts = []
        for op in ops:
            if op.startswith('"') or (op.startswith("'") and op.endswith("'") and len(op) != 3):
                inner = op[1:-1]
                if '"' in inner or "'" in op[:1]:
                    parts.extend(str(ord(ch)) for ch in inner)
                else:
                    parts.append('"' + inner + '"')
            elif op.startswith("'") and op.endswith("'") and len(op) == 3:
                parts.append(str(ord(op[1])))
            else:
                parts.append(masm_imm(self.number(op)))
        self.body.append("    DB " + ", ".join(parts))

    def emit_dc(self, ops: list[str], directive: str) -> None:
        parts = []
        for op in ops:
            if self.is_number(op):
                parts.append(masm_imm(self.number(op)))
            else:
                self.use_sym(op)
                parts.append("OFFSET " + op)
        self.body.append(f"    {directive} " + ", ".join(parts))

    def is_number(self, text: str) -> bool:
        token = text.strip()
        if token in self.equ:
            return True
        return re.fullmatch(r"-?(?:0x[0-9A-Fa-f]+|\d+)", token) is not None


def fuse_adrp(lines: list[tuple[str, str]]) -> list[tuple[str, str]]:
    out = []
    index = 0
    while index < len(lines):
        text, origin = lines[index]
        if index + 1 < len(lines):
            nxt, _ = lines[index + 1]
            first = re.fullmatch(r"adrp\s+(x\d+)\s*,\s*([A-Za-z_][A-Za-z0-9_]*)\s*", text, re.I)
            second = re.fullmatch(r"add\s+(x\d+)\s*,\s*(x\d+)\s*,\s*([A-Za-z_][A-Za-z0-9_]*)\s*", nxt, re.I)
            if (first and second and first.group(1).lower() == second.group(1).lower()
                    == second.group(2).lower() and first.group(2) == second.group(3)):
                out.append((f"lea {first.group(1)}, {first.group(2)}", origin))
                index += 2
                continue
        out.append(lines[index])
        index += 1
    return out


def include_path(root_src: str, rel: str) -> str:
    rel = rel.replace("/", os.sep)
    direct = os.path.join(ROOT, rel)
    if os.path.isfile(direct):
        return direct
    beside = os.path.join(root_src, os.path.basename(rel))
    if os.path.isfile(beside):
        return beside
    raise AsmError(f"missing include {rel}")


def main() -> int:
    os.makedirs(OUT, exist_ok=True)
    expander = Expander(ROOT)
    # INCLUDE paths in the sources are project-root relative. Point the
    # expander at the project root and let process_file join them.
    expanded = {}
    equs = {}
    for name in FILES:
        try:
            lines, equ = expander.expand_file(os.path.join("Forth", "kernel", "arm64", name)
                                              if False else name)
        except AsmError as exc:
            print(f"{name}: {exc}", file=sys.stderr)
            return 1
        expanded[name] = lines
        equs[name] = equ
    # The expander joins INCLUDE with ROOT only when we pass ROOT as root.
    return 0


if __name__ == "__main__":
    # Re-bind include root: sources say INCLUDE Forth/kernel/arm64/vm.inc.
    Expander.process_file = Expander.process_file

    class RootExpander(Expander):
        def process_line(self, line: str) -> str | None:
            if not line:
                return None
            token, rest = first_token(line)
            if (self.mode[-1] == "run" and self.defining is None and not self.expect_proto
                    and token.upper() == "INCLUDE"):
                path = include_path(SRC, rest.strip().strip('"'))
                self.process_file(path)
                return None
            return super().process_line(line)

    def run() -> int:
        os.makedirs(OUT, exist_ok=True)
        expander = RootExpander(SRC)
        expanded: dict[str, list[tuple[str, str]]] = {}
        equs: dict[str, dict[str, int]] = {}
        for name in FILES:
            try:
                lines, equ = expander.expand_file(name)
            except AsmError as exc:
                print(f"{name}: {exc}", file=sys.stderr)
                return 1
            except OSError as exc:
                print(f"{name}: {exc}", file=sys.stderr)
                return 1
            expanded[name] = lines
            equs[name] = equ
        everywhere: set[str] = set()
        sections: dict[str, str] = {}
        locals_: dict[str, set[str]] = {}
        for name, lines in expanded.items():
            local: set[str] = set()
            scan_labels(lines, local, everywhere, sections)
            locals_[name] = local
        calls: set[str] = set()
        for name, lines in expanded.items():
            fused = fuse_adrp(lines)
            translator = Translator(equs[name], locals_[name], everywhere, sections, name)
            try:
                text = translator.translate(fused)
            except AsmError as exc:
                print(exc, file=sys.stderr)
                return 1
            calls |= translator.c_calls
            dest = os.path.join(OUT, name)
            with open(dest, "w", encoding="utf-8", newline="") as handle:
                handle.write(text)
            print(f"{name}: {len(fused)} lines -> {len(text.splitlines())}")
        print("C calls:", ", ".join(sorted(calls)))
        return 0

    sys.exit(run())
