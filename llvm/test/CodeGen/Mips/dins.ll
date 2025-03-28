; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc -O2 -verify-machineinstrs -mtriple=mips64-elf -mcpu=mips64r2 \
; RUN:   -target-abi=n64 < %s -o - | FileCheck %s -check-prefix=MIPS64R2
; RUN: llc -O2 -verify-machineinstrs -mtriple=mips-elf -mcpu=mips32r2 < %s -o - \
; RUN:   | FileCheck %s -check-prefix=MIPS32R2
; RUN: llc -O2 -verify-machineinstrs -mtriple=mips-elf -mattr=mips16 < %s -o - \
; RUN:   | FileCheck %s -check-prefix=MIPS16
; RUN: llc -O2 -verify-machineinstrs -mtriple=mips64-elf -mcpu=mips64r2 \
; RUN:   -target-abi=n32 < %s -o - | FileCheck %s -check-prefix=MIPS64R2N32

; #include <stdint.h>
; #include <stdio.h>
; struct cvmx_buf_ptr {

;   struct {
;     unsigned long long addr :37;
;     unsigned long long addr1 :15;
;     unsigned int length:14;
;     uint64_t total_bytes:16;
;     uint64_t segs : 6;
;   } s;
; }
;
; unsigned long long foo(volatile struct cvmx_buf_ptr bufptr) {
;   bufptr.s.addr = 123;
;   bufptr.s.segs = 4;
;   bufptr.s.length = 5;
;   bufptr.s.total_bytes = bufptr.s.length;
;   return bufptr.s.addr;
; }

; Testing of selection INS/DINS instruction

define i64 @f123(i64 inreg %bufptr.coerce0, i64 inreg %bufptr.coerce1) local_unnamed_addr #0 {
; MIPS64R2-LABEL: f123:
; MIPS64R2:       # %bb.0: # %entry
; MIPS64R2-NEXT:    daddiu $sp, $sp, -16
; MIPS64R2-NEXT:    .cfi_def_cfa_offset 16
; MIPS64R2-NEXT:    sd $4, 8($sp)
; MIPS64R2-NEXT:    sd $5, 0($sp)
; MIPS64R2-NEXT:    daddiu $1, $zero, 123
; MIPS64R2-NEXT:    ld $2, 8($sp)
; MIPS64R2-NEXT:    dinsm $2, $1, 27, 37
; MIPS64R2-NEXT:    sd $2, 8($sp)
; MIPS64R2-NEXT:    daddiu $1, $zero, 4
; MIPS64R2-NEXT:    ld $2, 0($sp)
; MIPS64R2-NEXT:    dinsm $2, $1, 28, 6
; MIPS64R2-NEXT:    daddiu $1, $zero, 5
; MIPS64R2-NEXT:    sd $2, 0($sp)
; MIPS64R2-NEXT:    ld $2, 0($sp)
; MIPS64R2-NEXT:    dinsu $2, $1, 50, 14
; MIPS64R2-NEXT:    sd $2, 0($sp)
; MIPS64R2-NEXT:    ld $1, 0($sp)
; MIPS64R2-NEXT:    dsrl $1, $1, 50
; MIPS64R2-NEXT:    ld $2, 0($sp)
; MIPS64R2-NEXT:    dinsu $2, $1, 34, 16
; MIPS64R2-NEXT:    sd $2, 0($sp)
; MIPS64R2-NEXT:    ld $1, 8($sp)
; MIPS64R2-NEXT:    dsrl $2, $1, 27
; MIPS64R2-NEXT:    jr $ra
; MIPS64R2-NEXT:    daddiu $sp, $sp, 16
;
; MIPS32R2-LABEL: f123:
; MIPS32R2:       # %bb.0: # %entry
; MIPS32R2-NEXT:    addiu $sp, $sp, -16
; MIPS32R2-NEXT:    .cfi_def_cfa_offset 16
; MIPS32R2-NEXT:    lw $1, 8($sp)
; MIPS32R2-NEXT:    lw $1, 12($sp)
; MIPS32R2-NEXT:    addiu $2, $zero, 3
; MIPS32R2-NEXT:    sw $2, 8($sp)
; MIPS32R2-NEXT:    ext $1, $1, 0, 27
; MIPS32R2-NEXT:    lui $2, 55296
; MIPS32R2-NEXT:    or $1, $1, $2
; MIPS32R2-NEXT:    sw $1, 12($sp)
; MIPS32R2-NEXT:    addiu $1, $zero, -4
; MIPS32R2-NEXT:    lw $2, 0($sp)
; MIPS32R2-NEXT:    and $1, $2, $1
; MIPS32R2-NEXT:    lw $2, 4($sp)
; MIPS32R2-NEXT:    sw $1, 0($sp)
; MIPS32R2-NEXT:    ext $1, $2, 0, 28
; MIPS32R2-NEXT:    lui $2, 16384
; MIPS32R2-NEXT:    or $1, $1, $2
; MIPS32R2-NEXT:    lui $2, 20
; MIPS32R2-NEXT:    sw $1, 4($sp)
; MIPS32R2-NEXT:    lw $1, 0($sp)
; MIPS32R2-NEXT:    lw $3, 4($sp)
; MIPS32R2-NEXT:    sw $3, 4($sp)
; MIPS32R2-NEXT:    ext $1, $1, 0, 18
; MIPS32R2-NEXT:    or $1, $1, $2
; MIPS32R2-NEXT:    sw $1, 0($sp)
; MIPS32R2-NEXT:    lw $1, 4($sp)
; MIPS32R2-NEXT:    lw $1, 0($sp)
; MIPS32R2-NEXT:    lw $2, 0($sp)
; MIPS32R2-NEXT:    lw $3, 4($sp)
; MIPS32R2-NEXT:    sw $3, 4($sp)
; MIPS32R2-NEXT:    srl $1, $1, 18
; MIPS32R2-NEXT:    ins $2, $1, 2, 16
; MIPS32R2-NEXT:    sw $2, 0($sp)
; MIPS32R2-NEXT:    lw $1, 8($sp)
; MIPS32R2-NEXT:    sll $2, $1, 5
; MIPS32R2-NEXT:    lw $3, 12($sp)
; MIPS32R2-NEXT:    srl $3, $3, 27
; MIPS32R2-NEXT:    or $3, $3, $2
; MIPS32R2-NEXT:    srl $2, $1, 27
; MIPS32R2-NEXT:    jr $ra
; MIPS32R2-NEXT:    addiu $sp, $sp, 16
;
; MIPS16-LABEL: f123:
; MIPS16:       # %bb.0: # %entry
; MIPS16-NEXT:    save 16 # 16 bit inst
; MIPS16-EMPTY:
; MIPS16-NEXT:    .cfi_def_cfa_offset 16
; MIPS16-NEXT:    lw $2, 8($sp)
; MIPS16-NEXT:    lw $2, 12($sp)
; MIPS16-NEXT:    li $3, 3
; MIPS16-NEXT:    sw $3, 8($sp)
; MIPS16-NEXT:    lw $3, $CPI0_0 # 16 bit inst
; MIPS16-NEXT:    and $3, $2
; MIPS16-NEXT:    lw $2, $CPI0_1 # 16 bit inst
; MIPS16-NEXT:    or $2, $3
; MIPS16-NEXT:    sw $2, 12($sp)
; MIPS16-NEXT:    move $2, $zero
; MIPS16-NEXT:    addiu $2, -4
; MIPS16-NEXT:    lw $3, 0($sp)
; MIPS16-NEXT:    and $3, $2
; MIPS16-NEXT:    lw $2, 4($sp)
; MIPS16-NEXT:    sw $3, 0($sp)
; MIPS16-NEXT:    lw $3, $CPI0_2 # 16 bit inst
; MIPS16-NEXT:    and $3, $2
; MIPS16-NEXT:    lw $2, $CPI0_3 # 16 bit inst
; MIPS16-NEXT:    or $2, $3
; MIPS16-NEXT:    sw $2, 4($sp)
; MIPS16-NEXT:    lw $2, 0($sp)
; MIPS16-NEXT:    lw $3, 4($sp)
; MIPS16-NEXT:    sw $3, 4($sp)
; MIPS16-NEXT:    lw $3, $CPI0_4 # 16 bit inst
; MIPS16-NEXT:    and $3, $2
; MIPS16-NEXT:    lw $2, $CPI0_5 # 16 bit inst
; MIPS16-NEXT:    or $2, $3
; MIPS16-NEXT:    sw $2, 0($sp)
; MIPS16-NEXT:    lw $2, 4($sp)
; MIPS16-NEXT:    lw $2, 0($sp)
; MIPS16-NEXT:    lw $3, 0($sp)
; MIPS16-NEXT:    lw $4, 4($sp)
; MIPS16-NEXT:    sw $4, 4($sp)
; MIPS16-NEXT:    srl $2, $2, 16
; MIPS16-NEXT:    li $4, 65532
; MIPS16-NEXT:    and $4, $2
; MIPS16-NEXT:    lw $2, $CPI0_6 # 16 bit inst
; MIPS16-NEXT:    and $2, $3
; MIPS16-NEXT:    or $2, $4
; MIPS16-NEXT:    sw $2, 0($sp)
; MIPS16-NEXT:    lw $2, 12($sp)
; MIPS16-NEXT:    srl $2, $2, 27
; MIPS16-NEXT:    lw $4, 8($sp)
; MIPS16-NEXT:    sll $3, $4, 5
; MIPS16-NEXT:    or $3, $2
; MIPS16-NEXT:    srl $2, $4, 27
; MIPS16-NEXT:    restore 16 # 16 bit inst
; MIPS16-EMPTY:
; MIPS16-NEXT:    jrc $ra
; MIPS16-NEXT:    .p2align 2
; MIPS16-NEXT:  # %bb.1:
; MIPS16-NEXT:  $CPI0_0:
; MIPS16-NEXT:    .4byte 134217727 # 0x7ffffff
; MIPS16-NEXT:  $CPI0_1:
; MIPS16-NEXT:    .4byte 3623878656 # 0xd8000000
; MIPS16-NEXT:  $CPI0_2:
; MIPS16-NEXT:    .4byte 268435455 # 0xfffffff
; MIPS16-NEXT:  $CPI0_3:
; MIPS16-NEXT:    .4byte 1073741824 # 0x40000000
; MIPS16-NEXT:  $CPI0_4:
; MIPS16-NEXT:    .4byte 262143 # 0x3ffff
; MIPS16-NEXT:  $CPI0_5:
; MIPS16-NEXT:    .4byte 1310720 # 0x140000
; MIPS16-NEXT:  $CPI0_6:
; MIPS16-NEXT:    .4byte 4294705155 # 0xfffc0003
;
; MIPS64R2N32-LABEL: f123:
; MIPS64R2N32:       # %bb.0: # %entry
; MIPS64R2N32-NEXT:    addiu $sp, $sp, -16
; MIPS64R2N32-NEXT:    .cfi_def_cfa_offset 16
; MIPS64R2N32-NEXT:    sd $4, 8($sp)
; MIPS64R2N32-NEXT:    sd $5, 0($sp)
; MIPS64R2N32-NEXT:    daddiu $1, $zero, 123
; MIPS64R2N32-NEXT:    ld $2, 8($sp)
; MIPS64R2N32-NEXT:    dinsm $2, $1, 27, 37
; MIPS64R2N32-NEXT:    sd $2, 8($sp)
; MIPS64R2N32-NEXT:    daddiu $1, $zero, 4
; MIPS64R2N32-NEXT:    ld $2, 0($sp)
; MIPS64R2N32-NEXT:    dinsm $2, $1, 28, 6
; MIPS64R2N32-NEXT:    daddiu $1, $zero, 5
; MIPS64R2N32-NEXT:    sd $2, 0($sp)
; MIPS64R2N32-NEXT:    ld $2, 0($sp)
; MIPS64R2N32-NEXT:    dinsu $2, $1, 50, 14
; MIPS64R2N32-NEXT:    sd $2, 0($sp)
; MIPS64R2N32-NEXT:    ld $1, 0($sp)
; MIPS64R2N32-NEXT:    dsrl $1, $1, 50
; MIPS64R2N32-NEXT:    ld $2, 0($sp)
; MIPS64R2N32-NEXT:    dinsu $2, $1, 34, 16
; MIPS64R2N32-NEXT:    sd $2, 0($sp)
; MIPS64R2N32-NEXT:    ld $1, 8($sp)
; MIPS64R2N32-NEXT:    dsrl $2, $1, 27
; MIPS64R2N32-NEXT:    jr $ra
; MIPS64R2N32-NEXT:    addiu $sp, $sp, 16
entry:
  %bufptr.sroa.0 = alloca i64, align 8
  %bufptr.sroa.4 = alloca i64, align 8
  store i64 %bufptr.coerce0, ptr %bufptr.sroa.0, align 8
  store i64 %bufptr.coerce1, ptr %bufptr.sroa.4, align 8
  %bufptr.sroa.0.0.bufptr.sroa.0.0.bufptr.sroa.0.0.bf.load = load volatile i64, ptr %bufptr.sroa.0, align 8
  %bf.clear = and i64 %bufptr.sroa.0.0.bufptr.sroa.0.0.bufptr.sroa.0.0.bf.load, 134217727
  %bf.set = or i64 %bf.clear, 16508780544
  store volatile i64 %bf.set, ptr %bufptr.sroa.0, align 8
  %bufptr.sroa.4.0.bufptr.sroa.4.0.bufptr.sroa.4.8.bf.load2 = load volatile i64, ptr %bufptr.sroa.4, align 8
  %bf.clear3 = and i64 %bufptr.sroa.4.0.bufptr.sroa.4.0.bufptr.sroa.4.8.bf.load2, -16911433729
  %bf.set4 = or i64 %bf.clear3, 1073741824
  store volatile i64 %bf.set4, ptr %bufptr.sroa.4, align 8
  %bufptr.sroa.4.0.bufptr.sroa.4.0.bufptr.sroa.4.8.bf.load6 = load volatile i64, ptr %bufptr.sroa.4, align 8
  %bf.clear7 = and i64 %bufptr.sroa.4.0.bufptr.sroa.4.0.bufptr.sroa.4.8.bf.load6, 1125899906842623
  %bf.set8 = or i64 %bf.clear7, 5629499534213120
  store volatile i64 %bf.set8, ptr %bufptr.sroa.4, align 8
  %bufptr.sroa.4.0.bufptr.sroa.4.0.bufptr.sroa.4.8.bf.load11 = load volatile i64, ptr %bufptr.sroa.4, align 8
  %bf.lshr = lshr i64 %bufptr.sroa.4.0.bufptr.sroa.4.0.bufptr.sroa.4.8.bf.load11, 50
  %bufptr.sroa.4.0.bufptr.sroa.4.0.bufptr.sroa.4.8.bf.load13 = load volatile i64, ptr %bufptr.sroa.4, align 8
  %bf.shl = shl nuw nsw i64 %bf.lshr, 34
  %bf.clear14 = and i64 %bufptr.sroa.4.0.bufptr.sroa.4.0.bufptr.sroa.4.8.bf.load13, -1125882726973441
  %bf.set15 = or i64 %bf.clear14, %bf.shl
  store volatile i64 %bf.set15, ptr %bufptr.sroa.4, align 8
  %bufptr.sroa.0.0.bufptr.sroa.0.0.bufptr.sroa.0.0.bf.load17 = load volatile i64, ptr %bufptr.sroa.0, align 8
  %bf.lshr18 = lshr i64 %bufptr.sroa.0.0.bufptr.sroa.0.0.bufptr.sroa.0.0.bf.load17, 27
  ret i64 %bf.lshr18
}

; int foo(volatile int x) {
;   int y = x;
;   y = y & -4;
;   x = y | 8;
;   return y;
; }

define i32 @foo(i32 signext %x) {
; MIPS64R2-LABEL: foo:
; MIPS64R2:       # %bb.0: # %entry
; MIPS64R2-NEXT:    daddiu $sp, $sp, -16
; MIPS64R2-NEXT:    .cfi_def_cfa_offset 16
; MIPS64R2-NEXT:    sw $4, 12($sp)
; MIPS64R2-NEXT:    addiu $1, $zero, -4
; MIPS64R2-NEXT:    lw $2, 12($sp)
; MIPS64R2-NEXT:    and $2, $2, $1
; MIPS64R2-NEXT:    ori $1, $2, 8
; MIPS64R2-NEXT:    sw $1, 12($sp)
; MIPS64R2-NEXT:    jr $ra
; MIPS64R2-NEXT:    daddiu $sp, $sp, 16
;
; MIPS32R2-LABEL: foo:
; MIPS32R2:       # %bb.0: # %entry
; MIPS32R2-NEXT:    addiu $sp, $sp, -8
; MIPS32R2-NEXT:    .cfi_def_cfa_offset 8
; MIPS32R2-NEXT:    sw $4, 4($sp)
; MIPS32R2-NEXT:    addiu $1, $zero, -4
; MIPS32R2-NEXT:    lw $2, 4($sp)
; MIPS32R2-NEXT:    and $2, $2, $1
; MIPS32R2-NEXT:    ori $1, $2, 8
; MIPS32R2-NEXT:    sw $1, 4($sp)
; MIPS32R2-NEXT:    jr $ra
; MIPS32R2-NEXT:    addiu $sp, $sp, 8
;
; MIPS16-LABEL: foo:
; MIPS16:       # %bb.0: # %entry
; MIPS16-NEXT:    save 8 # 16 bit inst
; MIPS16-EMPTY:
; MIPS16-NEXT:    .cfi_def_cfa_offset 8
; MIPS16-NEXT:    sw $4, 4($sp)
; MIPS16-NEXT:    move $3, $zero
; MIPS16-NEXT:    addiu $3, -4
; MIPS16-NEXT:    lw $2, 4($sp)
; MIPS16-NEXT:    and $2, $3
; MIPS16-NEXT:    li $3, 8
; MIPS16-NEXT:    or $3, $2
; MIPS16-NEXT:    sw $3, 4($sp)
; MIPS16-NEXT:    restore 8 # 16 bit inst
; MIPS16-EMPTY:
; MIPS16-NEXT:    jrc $ra
;
; MIPS64R2N32-LABEL: foo:
; MIPS64R2N32:       # %bb.0: # %entry
; MIPS64R2N32-NEXT:    addiu $sp, $sp, -16
; MIPS64R2N32-NEXT:    .cfi_def_cfa_offset 16
; MIPS64R2N32-NEXT:    sw $4, 12($sp)
; MIPS64R2N32-NEXT:    addiu $1, $zero, -4
; MIPS64R2N32-NEXT:    lw $2, 12($sp)
; MIPS64R2N32-NEXT:    and $2, $2, $1
; MIPS64R2N32-NEXT:    ori $1, $2, 8
; MIPS64R2N32-NEXT:    sw $1, 12($sp)
; MIPS64R2N32-NEXT:    jr $ra
; MIPS64R2N32-NEXT:    addiu $sp, $sp, 16
entry:
  %x.addr = alloca i32, align 4
  store volatile i32 %x, ptr %x.addr, align 4
  %x.addr.0.x.addr.0. = load volatile i32, ptr %x.addr, align 4
  %and = and i32 %x.addr.0.x.addr.0., -4
  %or = or i32 %and, 8
  store volatile i32 %or, ptr %x.addr, align 4
  ret i32 %and
}

define i32 @pr125954(i32 %arg, i1 %c) {
; MIPS64R2-LABEL: pr125954:
; MIPS64R2:       # %bb.0:
; MIPS64R2-NEXT:    sll $1, $4, 0
; MIPS64R2-NEXT:    addiu $2, $zero, -1
; MIPS64R2-NEXT:    move $3, $1
; MIPS64R2-NEXT:    ins $3, $2, 8, 24
; MIPS64R2-NEXT:    andi $2, $1, 255
; MIPS64R2-NEXT:    sll $1, $5, 0
; MIPS64R2-NEXT:    andi $1, $1, 1
; MIPS64R2-NEXT:    jr $ra
; MIPS64R2-NEXT:    movn $2, $3, $1
;
; MIPS32R2-LABEL: pr125954:
; MIPS32R2:       # %bb.0:
; MIPS32R2-NEXT:    andi $2, $4, 255
; MIPS32R2-NEXT:    addiu $1, $zero, -256
; MIPS32R2-NEXT:    or $1, $2, $1
; MIPS32R2-NEXT:    andi $3, $5, 1
; MIPS32R2-NEXT:    jr $ra
; MIPS32R2-NEXT:    movn $2, $1, $3
;
; MIPS16-LABEL: pr125954:
; MIPS16:       # %bb.0:
; MIPS16-NEXT:    li $6, 1
; MIPS16-NEXT:    and $6, $5
; MIPS16-NEXT:    li $2, 255
; MIPS16-NEXT:    and $2, $4
; MIPS16-NEXT:    move $3, $zero
; MIPS16-NEXT:    beqz $6, $BB2_2 # 16 bit inst
; MIPS16-NEXT:  # %bb.1:
; MIPS16-NEXT:    addiu $3, -256
; MIPS16-NEXT:    or $2, $3
; MIPS16-NEXT:  $BB2_2:
; MIPS16-NEXT:    jrc $ra
;
; MIPS64R2N32-LABEL: pr125954:
; MIPS64R2N32:       # %bb.0:
; MIPS64R2N32-NEXT:    sll $1, $4, 0
; MIPS64R2N32-NEXT:    addiu $2, $zero, -1
; MIPS64R2N32-NEXT:    move $3, $1
; MIPS64R2N32-NEXT:    ins $3, $2, 8, 24
; MIPS64R2N32-NEXT:    andi $2, $1, 255
; MIPS64R2N32-NEXT:    sll $1, $5, 0
; MIPS64R2N32-NEXT:    andi $1, $1, 1
; MIPS64R2N32-NEXT:    jr $ra
; MIPS64R2N32-NEXT:    movn $2, $3, $1
  %and = and i32 %arg, 255
  %or = or i32 %and, -256
  %sel = select i1 %c, i32 %or, i32 %and
  ret i32 %sel
}
