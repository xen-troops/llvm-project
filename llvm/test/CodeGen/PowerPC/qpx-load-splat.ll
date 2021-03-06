; RUN: llc -mtriple=powerpc64le-unknown-linux-gnu -ppc-vsr-nums-as-vr \
; RUN:   -ppc-asm-full-reg-names -verify-machineinstrs < %s | FileCheck %s

; Function Attrs: norecurse nounwind readonly
define <4 x double> @foo(double* nocapture readonly %a) #0 {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxvdsx v2, 0, r3
; CHECK-NEXT:    vmr v3, v2
; CHECK-NEXT:    blr
entry:
  %0 = load double, double* %a, align 8
  %vecinit.i = insertelement <4 x double> undef, double %0, i32 0
  %shuffle.i = shufflevector <4 x double> %vecinit.i, <4 x double> undef, <4 x i32> zeroinitializer
  ret <4 x double> %shuffle.i
}

define <4 x double> @foox(double* nocapture readonly %a, i64 %idx) #0 {
; CHECK-LABEL: foox:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sldi r4, r4, 3
; CHECK-NEXT:    lxvdsx v2, r3, r4
; CHECK-NEXT:    vmr v3, v2
; CHECK-NEXT:    blr
entry:
  %p = getelementptr double, double* %a, i64 %idx
  %0 = load double, double* %p, align 8
  %vecinit.i = insertelement <4 x double> undef, double %0, i32 0
  %shuffle.i = shufflevector <4 x double> %vecinit.i, <4 x double> undef, <4 x i32> zeroinitializer
  ret <4 x double> %shuffle.i
}

define <4 x double> @fooxu(double* nocapture readonly %a, i64 %idx, double** %pptr) #0 {
; CHECK-LABEL: fooxu:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sldi r4, r4, 3
; CHECK-NEXT:    lfdux f0, r3, r4
; CHECK-NEXT:    xxspltd v2, vs0, 0
; CHECK-NEXT:    std r3, 0(r5)
; CHECK-NEXT:    vmr v3, v2
; CHECK-NEXT:    blr
entry:
  %p = getelementptr double, double* %a, i64 %idx
  %0 = load double, double* %p, align 8
  %vecinit.i = insertelement <4 x double> undef, double %0, i32 0
  %shuffle.i = shufflevector <4 x double> %vecinit.i, <4 x double> undef, <4 x i32> zeroinitializer
  store double* %p, double** %pptr, align 8
  ret <4 x double> %shuffle.i
}

define <4 x float> @foof(float* nocapture readonly %a) #0 {
; CHECK-LABEL: foof:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfiwzx f0, 0, r3
; CHECK-NEXT:    xxpermdi vs0, f0, f0, 2
; CHECK-NEXT:    xxspltw v2, vs0, 3
; CHECK-NEXT:    blr
entry:
  %0 = load float, float* %a, align 4
  %vecinit.i = insertelement <4 x float> undef, float %0, i32 0
  %shuffle.i = shufflevector <4 x float> %vecinit.i, <4 x float> undef, <4 x i32> zeroinitializer
  ret <4 x float> %shuffle.i
}

define <4 x float> @foofx(float* nocapture readonly %a, i64 %idx) #0 {
; CHECK-LABEL: foofx:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sldi r4, r4, 2
; CHECK-NEXT:    lfiwzx f0, r3, r4
; CHECK-NEXT:    xxpermdi vs0, f0, f0, 2
; CHECK-NEXT:    xxspltw v2, vs0, 3
; CHECK-NEXT:    blr
entry:
  %p = getelementptr float, float* %a, i64 %idx
  %0 = load float, float* %p, align 4
  %vecinit.i = insertelement <4 x float> undef, float %0, i32 0
  %shuffle.i = shufflevector <4 x float> %vecinit.i, <4 x float> undef, <4 x i32> zeroinitializer
  ret <4 x float> %shuffle.i
}


