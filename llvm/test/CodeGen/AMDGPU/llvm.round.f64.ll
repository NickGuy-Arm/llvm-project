; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn -mcpu=tahiti < %s | FileCheck -check-prefix=SI %s
; RUN: llc -mtriple=amdgcn -mcpu=hawaii < %s | FileCheck -check-prefix=CI %s

define amdgpu_kernel void @round_f64(ptr addrspace(1) %out, double %x) #0 {
; SI-LABEL: round_f64:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x9
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s5, 0xfffff
; SI-NEXT:    s_mov_b32 s4, s6
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_bfe_u32 s7, s3, 0xb0014
; SI-NEXT:    s_addk_i32 s7, 0xfc01
; SI-NEXT:    s_lshr_b64 s[4:5], s[4:5], s7
; SI-NEXT:    s_and_b32 s8, s3, 0x80000000
; SI-NEXT:    s_andn2_b64 s[4:5], s[2:3], s[4:5]
; SI-NEXT:    s_cmp_lt_i32 s7, 0
; SI-NEXT:    s_cselect_b32 s4, 0, s4
; SI-NEXT:    s_cselect_b32 s5, s8, s5
; SI-NEXT:    s_cmp_gt_i32 s7, 51
; SI-NEXT:    s_cselect_b32 s8, s2, s4
; SI-NEXT:    s_cselect_b32 s9, s3, s5
; SI-NEXT:    v_mov_b32_e32 v0, s8
; SI-NEXT:    v_mov_b32_e32 v1, s9
; SI-NEXT:    v_add_f64 v[0:1], s[2:3], -v[0:1]
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    v_cmp_ge_f64_e64 s[10:11], |v[0:1]|, 0.5
; SI-NEXT:    s_brev_b32 s2, -2
; SI-NEXT:    s_and_b64 s[10:11], s[10:11], exec
; SI-NEXT:    s_cselect_b32 s0, 0x3ff00000, 0
; SI-NEXT:    v_mov_b32_e32 v0, s0
; SI-NEXT:    v_mov_b32_e32 v1, s3
; SI-NEXT:    v_bfi_b32 v1, s2, v0, v1
; SI-NEXT:    v_mov_b32_e32 v0, 0
; SI-NEXT:    v_add_f64 v[0:1], s[8:9], v[0:1]
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; CI-LABEL: round_f64:
; CI:       ; %bb.0:
; CI-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x9
; CI-NEXT:    s_brev_b32 s5, -2
; CI-NEXT:    s_mov_b32 s7, 0xf000
; CI-NEXT:    s_mov_b32 s6, -1
; CI-NEXT:    s_waitcnt lgkmcnt(0)
; CI-NEXT:    v_trunc_f64_e32 v[0:1], s[2:3]
; CI-NEXT:    s_mov_b32 s4, s0
; CI-NEXT:    v_add_f64 v[2:3], s[2:3], -v[0:1]
; CI-NEXT:    v_cmp_ge_f64_e64 s[8:9], |v[2:3]|, 0.5
; CI-NEXT:    v_mov_b32_e32 v2, s3
; CI-NEXT:    s_and_b64 s[2:3], s[8:9], exec
; CI-NEXT:    s_cselect_b32 s0, 0x3ff00000, 0
; CI-NEXT:    v_mov_b32_e32 v3, s0
; CI-NEXT:    v_bfi_b32 v3, s5, v3, v2
; CI-NEXT:    v_mov_b32_e32 v2, 0
; CI-NEXT:    v_add_f64 v[0:1], v[0:1], v[2:3]
; CI-NEXT:    s_mov_b32 s5, s1
; CI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; CI-NEXT:    s_endpgm
  %result = call double @llvm.round.f64(double %x) #1
  store double %result, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @v_round_f64(ptr addrspace(1) %out, ptr addrspace(1) %in) #0 {
; SI-LABEL: v_round_f64:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, 0
; SI-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; SI-NEXT:    v_mov_b32_e32 v1, 0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b64 s[4:5], s[2:3]
; SI-NEXT:    buffer_load_dwordx2 v[2:3], v[0:1], s[4:7], 0 addr64
; SI-NEXT:    s_movk_i32 s4, 0xfc01
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_mov_b32 s3, 0xfffff
; SI-NEXT:    v_mov_b32_e32 v8, 0x3ff00000
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_bfe_u32 v4, v3, 20, 11
; SI-NEXT:    v_add_i32_e32 v6, vcc, s4, v4
; SI-NEXT:    v_lshr_b64 v[4:5], s[2:3], v6
; SI-NEXT:    v_and_b32_e32 v7, 0x80000000, v3
; SI-NEXT:    v_not_b32_e32 v5, v5
; SI-NEXT:    v_not_b32_e32 v4, v4
; SI-NEXT:    v_and_b32_e32 v5, v3, v5
; SI-NEXT:    v_and_b32_e32 v4, v2, v4
; SI-NEXT:    v_cmp_gt_i32_e32 vcc, 0, v6
; SI-NEXT:    v_cndmask_b32_e32 v5, v5, v7, vcc
; SI-NEXT:    v_cndmask_b32_e64 v4, v4, 0, vcc
; SI-NEXT:    v_cmp_lt_i32_e32 vcc, 51, v6
; SI-NEXT:    v_cndmask_b32_e32 v5, v5, v3, vcc
; SI-NEXT:    v_cndmask_b32_e32 v4, v4, v2, vcc
; SI-NEXT:    v_add_f64 v[6:7], v[2:3], -v[4:5]
; SI-NEXT:    s_brev_b32 s2, -2
; SI-NEXT:    v_cmp_ge_f64_e64 vcc, |v[6:7]|, 0.5
; SI-NEXT:    v_cndmask_b32_e32 v2, 0, v8, vcc
; SI-NEXT:    v_bfi_b32 v3, s2, v2, v3
; SI-NEXT:    v_mov_b32_e32 v2, v1
; SI-NEXT:    v_add_f64 v[2:3], v[4:5], v[2:3]
; SI-NEXT:    s_mov_b64 s[2:3], s[6:7]
; SI-NEXT:    buffer_store_dwordx2 v[2:3], v[0:1], s[0:3], 0 addr64
; SI-NEXT:    s_endpgm
;
; CI-LABEL: v_round_f64:
; CI:       ; %bb.0:
; CI-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x9
; CI-NEXT:    s_mov_b32 s7, 0xf000
; CI-NEXT:    s_mov_b32 s6, 0
; CI-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; CI-NEXT:    v_mov_b32_e32 v1, 0
; CI-NEXT:    s_waitcnt lgkmcnt(0)
; CI-NEXT:    s_mov_b64 s[4:5], s[2:3]
; CI-NEXT:    buffer_load_dwordx2 v[2:3], v[0:1], s[4:7], 0 addr64
; CI-NEXT:    v_mov_b32_e32 v8, 0x3ff00000
; CI-NEXT:    s_brev_b32 s2, -2
; CI-NEXT:    s_waitcnt vmcnt(0)
; CI-NEXT:    v_trunc_f64_e32 v[4:5], v[2:3]
; CI-NEXT:    v_add_f64 v[6:7], v[2:3], -v[4:5]
; CI-NEXT:    v_cmp_ge_f64_e64 vcc, |v[6:7]|, 0.5
; CI-NEXT:    v_cndmask_b32_e32 v2, 0, v8, vcc
; CI-NEXT:    v_bfi_b32 v3, s2, v2, v3
; CI-NEXT:    v_mov_b32_e32 v2, v1
; CI-NEXT:    v_add_f64 v[2:3], v[4:5], v[2:3]
; CI-NEXT:    s_mov_b64 s[2:3], s[6:7]
; CI-NEXT:    buffer_store_dwordx2 v[2:3], v[0:1], s[0:3], 0 addr64
; CI-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x() #1
  %gep = getelementptr double, ptr addrspace(1) %in, i32 %tid
  %out.gep = getelementptr double, ptr addrspace(1) %out, i32 %tid
  %x = load double, ptr addrspace(1) %gep
  %result = call double @llvm.round.f64(double %x) #1
  store double %result, ptr addrspace(1) %out.gep
  ret void
}

define amdgpu_kernel void @round_v2f64(ptr addrspace(1) %out, <2 x double> %in) #0 {
; SI-LABEL: round_v2f64:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx4 s[8:11], s[4:5], 0xd
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_mov_b32 s7, 0xfffff
; SI-NEXT:    s_mov_b32 s6, s2
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_bfe_u32 s0, s11, 0xb0014
; SI-NEXT:    s_add_i32 s12, s0, 0xfffffc01
; SI-NEXT:    s_lshr_b64 s[0:1], s[6:7], s12
; SI-NEXT:    s_and_b32 s3, s11, 0x80000000
; SI-NEXT:    s_andn2_b64 s[0:1], s[10:11], s[0:1]
; SI-NEXT:    s_cmp_lt_i32 s12, 0
; SI-NEXT:    s_cselect_b32 s0, 0, s0
; SI-NEXT:    s_cselect_b32 s1, s3, s1
; SI-NEXT:    s_cmp_gt_i32 s12, 51
; SI-NEXT:    s_cselect_b32 s12, s10, s0
; SI-NEXT:    s_cselect_b32 s13, s11, s1
; SI-NEXT:    v_mov_b32_e32 v0, s12
; SI-NEXT:    v_mov_b32_e32 v1, s13
; SI-NEXT:    v_add_f64 v[0:1], s[10:11], -v[0:1]
; SI-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x9
; SI-NEXT:    v_cmp_ge_f64_e64 s[14:15], |v[0:1]|, 0.5
; SI-NEXT:    s_brev_b32 s10, -2
; SI-NEXT:    s_and_b64 s[4:5], s[14:15], exec
; SI-NEXT:    s_cselect_b32 s3, 0x3ff00000, 0
; SI-NEXT:    v_mov_b32_e32 v0, s3
; SI-NEXT:    s_bfe_u32 s3, s9, 0xb0014
; SI-NEXT:    s_addk_i32 s3, 0xfc01
; SI-NEXT:    s_lshr_b64 s[4:5], s[6:7], s3
; SI-NEXT:    s_andn2_b64 s[4:5], s[8:9], s[4:5]
; SI-NEXT:    s_and_b32 s6, s9, 0x80000000
; SI-NEXT:    s_cmp_lt_i32 s3, 0
; SI-NEXT:    s_cselect_b32 s4, 0, s4
; SI-NEXT:    s_cselect_b32 s5, s6, s5
; SI-NEXT:    s_cmp_gt_i32 s3, 51
; SI-NEXT:    s_cselect_b32 s4, s8, s4
; SI-NEXT:    s_cselect_b32 s5, s9, s5
; SI-NEXT:    v_mov_b32_e32 v2, s4
; SI-NEXT:    v_mov_b32_e32 v3, s5
; SI-NEXT:    v_add_f64 v[2:3], s[8:9], -v[2:3]
; SI-NEXT:    v_mov_b32_e32 v1, s11
; SI-NEXT:    v_cmp_ge_f64_e64 s[6:7], |v[2:3]|, 0.5
; SI-NEXT:    v_bfi_b32 v1, s10, v0, v1
; SI-NEXT:    s_and_b64 s[6:7], s[6:7], exec
; SI-NEXT:    v_mov_b32_e32 v0, 0
; SI-NEXT:    s_cselect_b32 s3, 0x3ff00000, 0
; SI-NEXT:    v_add_f64 v[2:3], s[12:13], v[0:1]
; SI-NEXT:    v_mov_b32_e32 v1, s3
; SI-NEXT:    v_mov_b32_e32 v4, s9
; SI-NEXT:    v_bfi_b32 v1, s10, v1, v4
; SI-NEXT:    v_add_f64 v[0:1], s[4:5], v[0:1]
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; CI-LABEL: round_v2f64:
; CI:       ; %bb.0:
; CI-NEXT:    s_load_dwordx4 s[8:11], s[4:5], 0xd
; CI-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x9
; CI-NEXT:    s_brev_b32 s2, -2
; CI-NEXT:    v_mov_b32_e32 v0, 0
; CI-NEXT:    s_mov_b32 s3, 0xf000
; CI-NEXT:    s_waitcnt lgkmcnt(0)
; CI-NEXT:    v_trunc_f64_e32 v[2:3], s[10:11]
; CI-NEXT:    v_trunc_f64_e32 v[6:7], s[8:9]
; CI-NEXT:    v_add_f64 v[4:5], s[10:11], -v[2:3]
; CI-NEXT:    v_mov_b32_e32 v1, s11
; CI-NEXT:    v_cmp_ge_f64_e64 s[4:5], |v[4:5]|, 0.5
; CI-NEXT:    v_add_f64 v[4:5], s[8:9], -v[6:7]
; CI-NEXT:    s_and_b64 s[4:5], s[4:5], exec
; CI-NEXT:    s_cselect_b32 s4, 0x3ff00000, 0
; CI-NEXT:    v_mov_b32_e32 v8, s4
; CI-NEXT:    v_cmp_ge_f64_e64 s[4:5], |v[4:5]|, 0.5
; CI-NEXT:    v_bfi_b32 v1, s2, v8, v1
; CI-NEXT:    s_and_b64 s[4:5], s[4:5], exec
; CI-NEXT:    s_cselect_b32 s4, 0x3ff00000, 0
; CI-NEXT:    v_add_f64 v[2:3], v[2:3], v[0:1]
; CI-NEXT:    v_mov_b32_e32 v1, s4
; CI-NEXT:    v_mov_b32_e32 v4, s9
; CI-NEXT:    v_bfi_b32 v1, s2, v1, v4
; CI-NEXT:    v_add_f64 v[0:1], v[6:7], v[0:1]
; CI-NEXT:    s_mov_b32 s2, -1
; CI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[0:3], 0
; CI-NEXT:    s_endpgm
  %result = call <2 x double> @llvm.round.v2f64(<2 x double> %in) #1
  store <2 x double> %result, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @round_v4f64(ptr addrspace(1) %out, <4 x double> %in) #0 {
; SI-LABEL: round_v4f64:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx8 s[8:15], s[4:5], 0x11
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_mov_b32 s7, 0xfffff
; SI-NEXT:    s_mov_b32 s6, s2
; SI-NEXT:    v_mov_b32_e32 v4, 0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_bfe_u32 s0, s11, 0xb0014
; SI-NEXT:    s_add_i32 s16, s0, 0xfffffc01
; SI-NEXT:    s_lshr_b64 s[0:1], s[6:7], s16
; SI-NEXT:    s_and_b32 s3, s11, 0x80000000
; SI-NEXT:    s_andn2_b64 s[0:1], s[10:11], s[0:1]
; SI-NEXT:    s_cmp_lt_i32 s16, 0
; SI-NEXT:    s_cselect_b32 s0, 0, s0
; SI-NEXT:    s_cselect_b32 s1, s3, s1
; SI-NEXT:    s_cmp_gt_i32 s16, 51
; SI-NEXT:    s_cselect_b32 s16, s10, s0
; SI-NEXT:    s_cselect_b32 s17, s11, s1
; SI-NEXT:    v_mov_b32_e32 v0, s16
; SI-NEXT:    v_mov_b32_e32 v1, s17
; SI-NEXT:    v_add_f64 v[0:1], s[10:11], -v[0:1]
; SI-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x9
; SI-NEXT:    v_cmp_ge_f64_e64 s[18:19], |v[0:1]|, 0.5
; SI-NEXT:    v_mov_b32_e32 v1, s11
; SI-NEXT:    s_and_b64 s[4:5], s[18:19], exec
; SI-NEXT:    s_cselect_b32 s3, 0x3ff00000, 0
; SI-NEXT:    v_mov_b32_e32 v0, s3
; SI-NEXT:    s_bfe_u32 s3, s9, 0xb0014
; SI-NEXT:    s_addk_i32 s3, 0xfc01
; SI-NEXT:    s_lshr_b64 s[4:5], s[6:7], s3
; SI-NEXT:    s_andn2_b64 s[4:5], s[8:9], s[4:5]
; SI-NEXT:    s_and_b32 s10, s9, 0x80000000
; SI-NEXT:    s_cmp_lt_i32 s3, 0
; SI-NEXT:    s_cselect_b32 s4, 0, s4
; SI-NEXT:    s_cselect_b32 s5, s10, s5
; SI-NEXT:    s_cmp_gt_i32 s3, 51
; SI-NEXT:    s_brev_b32 s18, -2
; SI-NEXT:    s_cselect_b32 s4, s8, s4
; SI-NEXT:    v_bfi_b32 v5, s18, v0, v1
; SI-NEXT:    s_cselect_b32 s5, s9, s5
; SI-NEXT:    v_mov_b32_e32 v0, s4
; SI-NEXT:    v_mov_b32_e32 v1, s5
; SI-NEXT:    v_add_f64 v[0:1], s[8:9], -v[0:1]
; SI-NEXT:    v_add_f64 v[2:3], s[16:17], v[4:5]
; SI-NEXT:    v_cmp_ge_f64_e64 s[10:11], |v[0:1]|, 0.5
; SI-NEXT:    v_mov_b32_e32 v6, s9
; SI-NEXT:    s_and_b64 s[10:11], s[10:11], exec
; SI-NEXT:    s_cselect_b32 s3, 0x3ff00000, 0
; SI-NEXT:    v_mov_b32_e32 v5, s3
; SI-NEXT:    s_bfe_u32 s3, s15, 0xb0014
; SI-NEXT:    s_addk_i32 s3, 0xfc01
; SI-NEXT:    s_lshr_b64 s[8:9], s[6:7], s3
; SI-NEXT:    s_andn2_b64 s[8:9], s[14:15], s[8:9]
; SI-NEXT:    s_and_b32 s10, s15, 0x80000000
; SI-NEXT:    s_cmp_lt_i32 s3, 0
; SI-NEXT:    s_cselect_b32 s8, 0, s8
; SI-NEXT:    s_cselect_b32 s9, s10, s9
; SI-NEXT:    s_cmp_gt_i32 s3, 51
; SI-NEXT:    s_cselect_b32 s8, s14, s8
; SI-NEXT:    s_cselect_b32 s9, s15, s9
; SI-NEXT:    v_mov_b32_e32 v0, s8
; SI-NEXT:    v_mov_b32_e32 v1, s9
; SI-NEXT:    v_add_f64 v[0:1], s[14:15], -v[0:1]
; SI-NEXT:    v_bfi_b32 v5, s18, v5, v6
; SI-NEXT:    v_cmp_ge_f64_e64 s[10:11], |v[0:1]|, 0.5
; SI-NEXT:    v_add_f64 v[0:1], s[4:5], v[4:5]
; SI-NEXT:    s_and_b64 s[4:5], s[10:11], exec
; SI-NEXT:    s_cselect_b32 s3, 0x3ff00000, 0
; SI-NEXT:    v_mov_b32_e32 v8, s3
; SI-NEXT:    s_bfe_u32 s3, s13, 0xb0014
; SI-NEXT:    s_addk_i32 s3, 0xfc01
; SI-NEXT:    s_lshr_b64 s[4:5], s[6:7], s3
; SI-NEXT:    s_andn2_b64 s[4:5], s[12:13], s[4:5]
; SI-NEXT:    s_and_b32 s6, s13, 0x80000000
; SI-NEXT:    s_cmp_lt_i32 s3, 0
; SI-NEXT:    s_cselect_b32 s4, 0, s4
; SI-NEXT:    s_cselect_b32 s5, s6, s5
; SI-NEXT:    s_cmp_gt_i32 s3, 51
; SI-NEXT:    s_cselect_b32 s5, s13, s5
; SI-NEXT:    s_cselect_b32 s4, s12, s4
; SI-NEXT:    v_mov_b32_e32 v6, s5
; SI-NEXT:    v_mov_b32_e32 v5, s4
; SI-NEXT:    v_add_f64 v[6:7], s[12:13], -v[5:6]
; SI-NEXT:    v_mov_b32_e32 v9, s15
; SI-NEXT:    v_cmp_ge_f64_e64 s[6:7], |v[6:7]|, 0.5
; SI-NEXT:    v_bfi_b32 v5, s18, v8, v9
; SI-NEXT:    s_and_b64 s[6:7], s[6:7], exec
; SI-NEXT:    s_cselect_b32 s3, 0x3ff00000, 0
; SI-NEXT:    v_add_f64 v[6:7], s[8:9], v[4:5]
; SI-NEXT:    v_mov_b32_e32 v5, s3
; SI-NEXT:    v_mov_b32_e32 v8, s13
; SI-NEXT:    v_bfi_b32 v5, s18, v5, v8
; SI-NEXT:    v_add_f64 v[4:5], s[4:5], v[4:5]
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_store_dwordx4 v[4:7], off, s[0:3], 0 offset:16
; SI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; CI-LABEL: round_v4f64:
; CI:       ; %bb.0:
; CI-NEXT:    s_load_dwordx8 s[8:15], s[4:5], 0x11
; CI-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x9
; CI-NEXT:    s_brev_b32 s2, -2
; CI-NEXT:    v_mov_b32_e32 v4, 0
; CI-NEXT:    s_mov_b32 s3, 0xf000
; CI-NEXT:    s_waitcnt lgkmcnt(0)
; CI-NEXT:    v_trunc_f64_e32 v[0:1], s[10:11]
; CI-NEXT:    v_trunc_f64_e32 v[6:7], s[8:9]
; CI-NEXT:    v_add_f64 v[2:3], s[10:11], -v[0:1]
; CI-NEXT:    v_mov_b32_e32 v5, s11
; CI-NEXT:    v_cmp_ge_f64_e64 s[4:5], |v[2:3]|, 0.5
; CI-NEXT:    v_add_f64 v[2:3], s[8:9], -v[6:7]
; CI-NEXT:    s_and_b64 s[4:5], s[4:5], exec
; CI-NEXT:    s_cselect_b32 s4, 0x3ff00000, 0
; CI-NEXT:    v_mov_b32_e32 v8, s4
; CI-NEXT:    v_cmp_ge_f64_e64 s[4:5], |v[2:3]|, 0.5
; CI-NEXT:    v_bfi_b32 v5, s2, v8, v5
; CI-NEXT:    v_trunc_f64_e32 v[8:9], s[14:15]
; CI-NEXT:    s_and_b64 s[4:5], s[4:5], exec
; CI-NEXT:    v_add_f64 v[2:3], v[0:1], v[4:5]
; CI-NEXT:    s_cselect_b32 s4, 0x3ff00000, 0
; CI-NEXT:    v_add_f64 v[0:1], s[14:15], -v[8:9]
; CI-NEXT:    v_mov_b32_e32 v5, s4
; CI-NEXT:    v_mov_b32_e32 v10, s9
; CI-NEXT:    v_bfi_b32 v5, s2, v5, v10
; CI-NEXT:    v_cmp_ge_f64_e64 s[4:5], |v[0:1]|, 0.5
; CI-NEXT:    v_trunc_f64_e32 v[10:11], s[12:13]
; CI-NEXT:    v_add_f64 v[0:1], v[6:7], v[4:5]
; CI-NEXT:    s_and_b64 s[4:5], s[4:5], exec
; CI-NEXT:    v_add_f64 v[6:7], s[12:13], -v[10:11]
; CI-NEXT:    s_cselect_b32 s4, 0x3ff00000, 0
; CI-NEXT:    v_mov_b32_e32 v5, s4
; CI-NEXT:    v_cmp_ge_f64_e64 s[4:5], |v[6:7]|, 0.5
; CI-NEXT:    v_mov_b32_e32 v12, s15
; CI-NEXT:    s_and_b64 s[4:5], s[4:5], exec
; CI-NEXT:    v_bfi_b32 v5, s2, v5, v12
; CI-NEXT:    s_cselect_b32 s4, 0x3ff00000, 0
; CI-NEXT:    v_add_f64 v[6:7], v[8:9], v[4:5]
; CI-NEXT:    v_mov_b32_e32 v5, s4
; CI-NEXT:    v_mov_b32_e32 v8, s13
; CI-NEXT:    v_bfi_b32 v5, s2, v5, v8
; CI-NEXT:    v_add_f64 v[4:5], v[10:11], v[4:5]
; CI-NEXT:    s_mov_b32 s2, -1
; CI-NEXT:    buffer_store_dwordx4 v[4:7], off, s[0:3], 0 offset:16
; CI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[0:3], 0
; CI-NEXT:    s_endpgm
  %result = call <4 x double> @llvm.round.v4f64(<4 x double> %in) #1
  store <4 x double> %result, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @round_v8f64(ptr addrspace(1) %out, <8 x double> %in) #0 {
; SI-LABEL: round_v8f64:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx16 s[8:23], s[4:5], 0x19
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_mov_b32 s7, 0xfffff
; SI-NEXT:    s_mov_b32 s6, s2
; SI-NEXT:    v_mov_b32_e32 v8, 0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_bfe_u32 s0, s11, 0xb0014
; SI-NEXT:    s_add_i32 s24, s0, 0xfffffc01
; SI-NEXT:    s_lshr_b64 s[0:1], s[6:7], s24
; SI-NEXT:    s_and_b32 s3, s11, 0x80000000
; SI-NEXT:    s_andn2_b64 s[0:1], s[10:11], s[0:1]
; SI-NEXT:    s_cmp_lt_i32 s24, 0
; SI-NEXT:    s_cselect_b32 s0, 0, s0
; SI-NEXT:    s_cselect_b32 s1, s3, s1
; SI-NEXT:    s_cmp_gt_i32 s24, 51
; SI-NEXT:    s_cselect_b32 s24, s10, s0
; SI-NEXT:    s_cselect_b32 s25, s11, s1
; SI-NEXT:    v_mov_b32_e32 v0, s24
; SI-NEXT:    v_mov_b32_e32 v1, s25
; SI-NEXT:    v_add_f64 v[0:1], s[10:11], -v[0:1]
; SI-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x9
; SI-NEXT:    v_cmp_ge_f64_e64 s[26:27], |v[0:1]|, 0.5
; SI-NEXT:    v_mov_b32_e32 v1, s11
; SI-NEXT:    s_and_b64 s[4:5], s[26:27], exec
; SI-NEXT:    s_cselect_b32 s4, 0x3ff00000, 0
; SI-NEXT:    v_mov_b32_e32 v0, s4
; SI-NEXT:    s_bfe_u32 s4, s9, 0xb0014
; SI-NEXT:    s_add_i32 s10, s4, 0xfffffc01
; SI-NEXT:    s_lshr_b64 s[4:5], s[6:7], s10
; SI-NEXT:    s_andn2_b64 s[4:5], s[8:9], s[4:5]
; SI-NEXT:    s_and_b32 s11, s9, 0x80000000
; SI-NEXT:    s_cmp_lt_i32 s10, 0
; SI-NEXT:    s_cselect_b32 s4, 0, s4
; SI-NEXT:    s_cselect_b32 s5, s11, s5
; SI-NEXT:    s_cmp_gt_i32 s10, 51
; SI-NEXT:    s_brev_b32 s3, -2
; SI-NEXT:    s_cselect_b32 s4, s8, s4
; SI-NEXT:    v_bfi_b32 v9, s3, v0, v1
; SI-NEXT:    s_cselect_b32 s5, s9, s5
; SI-NEXT:    v_mov_b32_e32 v0, s4
; SI-NEXT:    v_mov_b32_e32 v1, s5
; SI-NEXT:    v_add_f64 v[0:1], s[8:9], -v[0:1]
; SI-NEXT:    v_mov_b32_e32 v5, s9
; SI-NEXT:    v_cmp_ge_f64_e64 s[10:11], |v[0:1]|, 0.5
; SI-NEXT:    v_add_f64 v[2:3], s[24:25], v[8:9]
; SI-NEXT:    s_and_b64 s[10:11], s[10:11], exec
; SI-NEXT:    s_cselect_b32 s8, 0x3ff00000, 0
; SI-NEXT:    v_mov_b32_e32 v4, s8
; SI-NEXT:    s_bfe_u32 s8, s15, 0xb0014
; SI-NEXT:    s_add_i32 s10, s8, 0xfffffc01
; SI-NEXT:    s_lshr_b64 s[8:9], s[6:7], s10
; SI-NEXT:    s_andn2_b64 s[8:9], s[14:15], s[8:9]
; SI-NEXT:    s_and_b32 s11, s15, 0x80000000
; SI-NEXT:    s_cmp_lt_i32 s10, 0
; SI-NEXT:    s_cselect_b32 s8, 0, s8
; SI-NEXT:    s_cselect_b32 s9, s11, s9
; SI-NEXT:    s_cmp_gt_i32 s10, 51
; SI-NEXT:    s_cselect_b32 s8, s14, s8
; SI-NEXT:    s_cselect_b32 s9, s15, s9
; SI-NEXT:    v_mov_b32_e32 v0, s8
; SI-NEXT:    v_mov_b32_e32 v1, s9
; SI-NEXT:    v_add_f64 v[0:1], s[14:15], -v[0:1]
; SI-NEXT:    v_bfi_b32 v9, s3, v4, v5
; SI-NEXT:    v_cmp_ge_f64_e64 s[10:11], |v[0:1]|, 0.5
; SI-NEXT:    v_add_f64 v[0:1], s[4:5], v[8:9]
; SI-NEXT:    s_and_b64 s[4:5], s[10:11], exec
; SI-NEXT:    s_cselect_b32 s4, 0x3ff00000, 0
; SI-NEXT:    v_mov_b32_e32 v6, s4
; SI-NEXT:    s_bfe_u32 s4, s13, 0xb0014
; SI-NEXT:    s_add_i32 s10, s4, 0xfffffc01
; SI-NEXT:    s_lshr_b64 s[4:5], s[6:7], s10
; SI-NEXT:    s_andn2_b64 s[4:5], s[12:13], s[4:5]
; SI-NEXT:    s_and_b32 s11, s13, 0x80000000
; SI-NEXT:    s_cmp_lt_i32 s10, 0
; SI-NEXT:    s_cselect_b32 s4, 0, s4
; SI-NEXT:    s_cselect_b32 s5, s11, s5
; SI-NEXT:    s_cmp_gt_i32 s10, 51
; SI-NEXT:    s_cselect_b32 s4, s12, s4
; SI-NEXT:    s_cselect_b32 s5, s13, s5
; SI-NEXT:    v_mov_b32_e32 v4, s4
; SI-NEXT:    v_mov_b32_e32 v5, s5
; SI-NEXT:    v_add_f64 v[4:5], s[12:13], -v[4:5]
; SI-NEXT:    v_mov_b32_e32 v7, s15
; SI-NEXT:    v_cmp_ge_f64_e64 s[10:11], |v[4:5]|, 0.5
; SI-NEXT:    v_bfi_b32 v9, s3, v6, v7
; SI-NEXT:    v_add_f64 v[6:7], s[8:9], v[8:9]
; SI-NEXT:    s_and_b64 s[8:9], s[10:11], exec
; SI-NEXT:    s_cselect_b32 s8, 0x3ff00000, 0
; SI-NEXT:    v_mov_b32_e32 v9, s8
; SI-NEXT:    s_bfe_u32 s8, s19, 0xb0014
; SI-NEXT:    s_add_i32 s10, s8, 0xfffffc01
; SI-NEXT:    s_lshr_b64 s[8:9], s[6:7], s10
; SI-NEXT:    s_andn2_b64 s[8:9], s[18:19], s[8:9]
; SI-NEXT:    s_and_b32 s11, s19, 0x80000000
; SI-NEXT:    s_cmp_lt_i32 s10, 0
; SI-NEXT:    s_cselect_b32 s8, 0, s8
; SI-NEXT:    s_cselect_b32 s9, s11, s9
; SI-NEXT:    s_cmp_gt_i32 s10, 51
; SI-NEXT:    s_cselect_b32 s8, s18, s8
; SI-NEXT:    s_cselect_b32 s9, s19, s9
; SI-NEXT:    v_mov_b32_e32 v4, s8
; SI-NEXT:    v_mov_b32_e32 v5, s9
; SI-NEXT:    v_add_f64 v[4:5], s[18:19], -v[4:5]
; SI-NEXT:    v_mov_b32_e32 v10, s13
; SI-NEXT:    v_cmp_ge_f64_e64 s[10:11], |v[4:5]|, 0.5
; SI-NEXT:    v_bfi_b32 v9, s3, v9, v10
; SI-NEXT:    v_add_f64 v[4:5], s[4:5], v[8:9]
; SI-NEXT:    s_and_b64 s[4:5], s[10:11], exec
; SI-NEXT:    s_cselect_b32 s4, 0x3ff00000, 0
; SI-NEXT:    v_mov_b32_e32 v12, s4
; SI-NEXT:    s_bfe_u32 s4, s17, 0xb0014
; SI-NEXT:    s_add_i32 s10, s4, 0xfffffc01
; SI-NEXT:    s_lshr_b64 s[4:5], s[6:7], s10
; SI-NEXT:    s_andn2_b64 s[4:5], s[16:17], s[4:5]
; SI-NEXT:    s_and_b32 s11, s17, 0x80000000
; SI-NEXT:    s_cmp_lt_i32 s10, 0
; SI-NEXT:    s_cselect_b32 s4, 0, s4
; SI-NEXT:    s_cselect_b32 s5, s11, s5
; SI-NEXT:    s_cmp_gt_i32 s10, 51
; SI-NEXT:    s_cselect_b32 s5, s17, s5
; SI-NEXT:    s_cselect_b32 s4, s16, s4
; SI-NEXT:    v_mov_b32_e32 v10, s5
; SI-NEXT:    v_mov_b32_e32 v9, s4
; SI-NEXT:    v_add_f64 v[10:11], s[16:17], -v[9:10]
; SI-NEXT:    v_mov_b32_e32 v13, s19
; SI-NEXT:    v_cmp_ge_f64_e64 s[10:11], |v[10:11]|, 0.5
; SI-NEXT:    v_bfi_b32 v9, s3, v12, v13
; SI-NEXT:    v_add_f64 v[12:13], s[8:9], v[8:9]
; SI-NEXT:    s_and_b64 s[8:9], s[10:11], exec
; SI-NEXT:    s_cselect_b32 s8, 0x3ff00000, 0
; SI-NEXT:    v_mov_b32_e32 v14, s8
; SI-NEXT:    s_bfe_u32 s8, s23, 0xb0014
; SI-NEXT:    s_add_i32 s10, s8, 0xfffffc01
; SI-NEXT:    s_lshr_b64 s[8:9], s[6:7], s10
; SI-NEXT:    s_andn2_b64 s[8:9], s[22:23], s[8:9]
; SI-NEXT:    s_and_b32 s11, s23, 0x80000000
; SI-NEXT:    s_cmp_lt_i32 s10, 0
; SI-NEXT:    s_cselect_b32 s8, 0, s8
; SI-NEXT:    s_cselect_b32 s9, s11, s9
; SI-NEXT:    s_cmp_gt_i32 s10, 51
; SI-NEXT:    s_cselect_b32 s9, s23, s9
; SI-NEXT:    s_cselect_b32 s8, s22, s8
; SI-NEXT:    v_mov_b32_e32 v10, s9
; SI-NEXT:    v_mov_b32_e32 v9, s8
; SI-NEXT:    v_add_f64 v[10:11], s[22:23], -v[9:10]
; SI-NEXT:    v_mov_b32_e32 v15, s17
; SI-NEXT:    v_cmp_ge_f64_e64 s[10:11], |v[10:11]|, 0.5
; SI-NEXT:    v_bfi_b32 v9, s3, v14, v15
; SI-NEXT:    v_add_f64 v[10:11], s[4:5], v[8:9]
; SI-NEXT:    s_and_b64 s[4:5], s[10:11], exec
; SI-NEXT:    s_cselect_b32 s4, 0x3ff00000, 0
; SI-NEXT:    v_mov_b32_e32 v9, s4
; SI-NEXT:    s_bfe_u32 s4, s21, 0xb0014
; SI-NEXT:    s_add_i32 s10, s4, 0xfffffc01
; SI-NEXT:    s_lshr_b64 s[4:5], s[6:7], s10
; SI-NEXT:    s_andn2_b64 s[4:5], s[20:21], s[4:5]
; SI-NEXT:    s_and_b32 s6, s21, 0x80000000
; SI-NEXT:    s_cmp_lt_i32 s10, 0
; SI-NEXT:    s_cselect_b32 s4, 0, s4
; SI-NEXT:    s_cselect_b32 s5, s6, s5
; SI-NEXT:    s_cmp_gt_i32 s10, 51
; SI-NEXT:    s_cselect_b32 s5, s21, s5
; SI-NEXT:    s_cselect_b32 s4, s20, s4
; SI-NEXT:    v_mov_b32_e32 v15, s5
; SI-NEXT:    v_mov_b32_e32 v14, s4
; SI-NEXT:    v_add_f64 v[14:15], s[20:21], -v[14:15]
; SI-NEXT:    v_mov_b32_e32 v16, s23
; SI-NEXT:    v_cmp_ge_f64_e64 s[6:7], |v[14:15]|, 0.5
; SI-NEXT:    v_bfi_b32 v9, s3, v9, v16
; SI-NEXT:    s_and_b64 s[6:7], s[6:7], exec
; SI-NEXT:    s_cselect_b32 s6, 0x3ff00000, 0
; SI-NEXT:    v_add_f64 v[16:17], s[8:9], v[8:9]
; SI-NEXT:    v_mov_b32_e32 v9, s6
; SI-NEXT:    v_mov_b32_e32 v14, s21
; SI-NEXT:    v_bfi_b32 v9, s3, v9, v14
; SI-NEXT:    v_add_f64 v[14:15], s[4:5], v[8:9]
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_store_dwordx4 v[14:17], off, s[0:3], 0 offset:48
; SI-NEXT:    buffer_store_dwordx4 v[10:13], off, s[0:3], 0 offset:32
; SI-NEXT:    buffer_store_dwordx4 v[4:7], off, s[0:3], 0 offset:16
; SI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; CI-LABEL: round_v8f64:
; CI:       ; %bb.0:
; CI-NEXT:    s_load_dwordx16 s[8:23], s[4:5], 0x19
; CI-NEXT:    s_brev_b32 s6, -2
; CI-NEXT:    v_mov_b32_e32 v12, 0
; CI-NEXT:    s_waitcnt lgkmcnt(0)
; CI-NEXT:    v_trunc_f64_e32 v[0:1], s[10:11]
; CI-NEXT:    v_trunc_f64_e32 v[4:5], s[8:9]
; CI-NEXT:    v_add_f64 v[2:3], s[10:11], -v[0:1]
; CI-NEXT:    v_add_f64 v[6:7], s[8:9], -v[4:5]
; CI-NEXT:    v_cmp_ge_f64_e64 s[0:1], |v[2:3]|, 0.5
; CI-NEXT:    v_cmp_ge_f64_e64 s[2:3], |v[6:7]|, 0.5
; CI-NEXT:    s_and_b64 s[0:1], s[0:1], exec
; CI-NEXT:    s_cselect_b32 s7, 0x3ff00000, 0
; CI-NEXT:    v_mov_b32_e32 v8, s11
; CI-NEXT:    s_and_b64 s[0:1], s[2:3], exec
; CI-NEXT:    v_mov_b32_e32 v2, s7
; CI-NEXT:    v_trunc_f64_e32 v[6:7], s[14:15]
; CI-NEXT:    v_bfi_b32 v13, s6, v2, v8
; CI-NEXT:    s_cselect_b32 s0, 0x3ff00000, 0
; CI-NEXT:    v_add_f64 v[2:3], v[0:1], v[12:13]
; CI-NEXT:    v_mov_b32_e32 v8, s0
; CI-NEXT:    v_mov_b32_e32 v9, s9
; CI-NEXT:    v_add_f64 v[0:1], s[14:15], -v[6:7]
; CI-NEXT:    v_bfi_b32 v13, s6, v8, v9
; CI-NEXT:    v_cmp_ge_f64_e64 s[0:1], |v[0:1]|, 0.5
; CI-NEXT:    v_add_f64 v[0:1], v[4:5], v[12:13]
; CI-NEXT:    v_trunc_f64_e32 v[4:5], s[12:13]
; CI-NEXT:    s_and_b64 s[0:1], s[0:1], exec
; CI-NEXT:    v_add_f64 v[8:9], s[12:13], -v[4:5]
; CI-NEXT:    s_cselect_b32 s0, 0x3ff00000, 0
; CI-NEXT:    v_mov_b32_e32 v10, s0
; CI-NEXT:    v_cmp_ge_f64_e64 s[0:1], |v[8:9]|, 0.5
; CI-NEXT:    v_trunc_f64_e32 v[8:9], s[18:19]
; CI-NEXT:    v_mov_b32_e32 v11, s15
; CI-NEXT:    v_bfi_b32 v13, s6, v10, v11
; CI-NEXT:    s_and_b64 s[0:1], s[0:1], exec
; CI-NEXT:    v_add_f64 v[10:11], s[18:19], -v[8:9]
; CI-NEXT:    s_cselect_b32 s0, 0x3ff00000, 0
; CI-NEXT:    v_add_f64 v[6:7], v[6:7], v[12:13]
; CI-NEXT:    v_mov_b32_e32 v13, s0
; CI-NEXT:    v_mov_b32_e32 v14, s13
; CI-NEXT:    v_cmp_ge_f64_e64 s[0:1], |v[10:11]|, 0.5
; CI-NEXT:    v_bfi_b32 v13, s6, v13, v14
; CI-NEXT:    v_trunc_f64_e32 v[14:15], s[16:17]
; CI-NEXT:    s_and_b64 s[0:1], s[0:1], exec
; CI-NEXT:    s_cselect_b32 s0, 0x3ff00000, 0
; CI-NEXT:    v_add_f64 v[10:11], s[16:17], -v[14:15]
; CI-NEXT:    v_add_f64 v[4:5], v[4:5], v[12:13]
; CI-NEXT:    v_mov_b32_e32 v13, s0
; CI-NEXT:    v_mov_b32_e32 v16, s19
; CI-NEXT:    v_bfi_b32 v13, s6, v13, v16
; CI-NEXT:    v_cmp_ge_f64_e64 s[0:1], |v[10:11]|, 0.5
; CI-NEXT:    v_trunc_f64_e32 v[16:17], s[22:23]
; CI-NEXT:    s_and_b64 s[0:1], s[0:1], exec
; CI-NEXT:    v_add_f64 v[18:19], s[22:23], -v[16:17]
; CI-NEXT:    s_cselect_b32 s0, 0x3ff00000, 0
; CI-NEXT:    v_add_f64 v[10:11], v[8:9], v[12:13]
; CI-NEXT:    v_mov_b32_e32 v8, s0
; CI-NEXT:    v_mov_b32_e32 v9, s17
; CI-NEXT:    v_cmp_ge_f64_e64 s[0:1], |v[18:19]|, 0.5
; CI-NEXT:    v_trunc_f64_e32 v[18:19], s[20:21]
; CI-NEXT:    v_bfi_b32 v13, s6, v8, v9
; CI-NEXT:    v_add_f64 v[8:9], v[14:15], v[12:13]
; CI-NEXT:    v_add_f64 v[13:14], s[20:21], -v[18:19]
; CI-NEXT:    s_and_b64 s[0:1], s[0:1], exec
; CI-NEXT:    v_cmp_ge_f64_e64 s[0:1], |v[13:14]|, 0.5
; CI-NEXT:    s_cselect_b32 s2, 0x3ff00000, 0
; CI-NEXT:    s_and_b64 s[0:1], s[0:1], exec
; CI-NEXT:    s_cselect_b32 s0, 0x3ff00000, 0
; CI-NEXT:    v_mov_b32_e32 v13, s2
; CI-NEXT:    v_mov_b32_e32 v14, s23
; CI-NEXT:    v_mov_b32_e32 v20, s0
; CI-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x9
; CI-NEXT:    v_bfi_b32 v13, s6, v13, v14
; CI-NEXT:    v_mov_b32_e32 v21, s21
; CI-NEXT:    v_add_f64 v[14:15], v[16:17], v[12:13]
; CI-NEXT:    v_bfi_b32 v13, s6, v20, v21
; CI-NEXT:    v_add_f64 v[12:13], v[18:19], v[12:13]
; CI-NEXT:    s_mov_b32 s3, 0xf000
; CI-NEXT:    s_mov_b32 s2, -1
; CI-NEXT:    s_waitcnt lgkmcnt(0)
; CI-NEXT:    buffer_store_dwordx4 v[12:15], off, s[0:3], 0 offset:48
; CI-NEXT:    buffer_store_dwordx4 v[8:11], off, s[0:3], 0 offset:32
; CI-NEXT:    buffer_store_dwordx4 v[4:7], off, s[0:3], 0 offset:16
; CI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[0:3], 0
; CI-NEXT:    s_endpgm
  %result = call <8 x double> @llvm.round.v8f64(<8 x double> %in) #1
  store <8 x double> %result, ptr addrspace(1) %out
  ret void
}

declare i32 @llvm.amdgcn.workitem.id.x() #1

declare double @llvm.round.f64(double) #1
declare <2 x double> @llvm.round.v2f64(<2 x double>) #1
declare <4 x double> @llvm.round.v4f64(<4 x double>) #1
declare <8 x double> @llvm.round.v8f64(<8 x double>) #1

attributes #0 = { nounwind }
attributes #1 = { nounwind readnone }
