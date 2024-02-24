; ModuleID = 'block.ll'
source_filename = "block.ll"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx13.0.0"

%swift.function = type { i8*, %swift.refcounted* }
%swift.refcounted = type { %swift.type*, i64 }
%swift.type = type { i64 }
%swift.full_boxmetadata = type { void (%swift.refcounted*)*, i8**, %swift.type, i32, i8* }
%TSi = type <{ i64 }>

@"$s5block6incremSiycvp" = hidden global %swift.function zeroinitializer, align 8
@"symbolic Si" = linkonce_odr hidden constant <{ [2 x i8], i8 }> <{ [2 x i8] c"Si", i8 0 }>, section "__TEXT,__swift5_typeref, regular", align 2
@"\01l__swift5_reflection_descriptor" = private constant { i32, i32, i32, i32 } { i32 1, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (<{ [2 x i8], i8 }>* @"symbolic Si" to i64), i64 ptrtoint (i32* getelementptr inbounds ({ i32, i32, i32, i32 }, { i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor", i32 0, i32 3) to i64)) to i32) }, section "__TEXT,__swift5_capture, regular", align 4
@metadata = private constant %swift.full_boxmetadata { void (%swift.refcounted*)* @objectdestroy, i8** null, %swift.type { i64 1024 }, i32 16, i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor" to i8*) }, align 8
@"\01l_entry_point" = private constant { i32, i32 } { i32 trunc (i64 sub (i64 ptrtoint (i32 (i32, i8**)* @main to i64), i64 ptrtoint ({ i32, i32 }* @"\01l_entry_point" to i64)) to i32), i32 0 }, section "__TEXT, __swift5_entry, regular, no_dead_strip", align 4
@__swift_reflection_version = linkonce_odr hidden constant i16 3
@llvm.used = appending global [4 x i8*] [i8* bitcast (i32 (i32, i8**)* @main to i8*), i8* bitcast ({ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor" to i8*), i8* bitcast ({ i32, i32 }* @"\01l_entry_point" to i8*), i8* bitcast (i16* @__swift_reflection_version to i8*)], section "llvm.metadata"

define i32 @main(i32 %0, i8** %1) #0 {
entry:
  %2 = bitcast i8** %1 to i8*
//返回值是个结构体 s5block15makeIncrementerSiycyF是调用的函数
  %3 = call swiftcc { i8*, %swift.refcounted* } @"$s5block15makeIncrementerSiycyF"()
  %4 = extractvalue { i8*, %swift.refcounted* } %3, 0
  %5 = extractvalue { i8*, %swift.refcounted* } %3, 1
  store i8* %4, i8** getelementptr inbounds (%swift.function, %swift.function* @"$s5block6incremSiycvp", i32 0, i32 0), align 8
  store %swift.refcounted* %5, %swift.refcounted** getelementptr inbounds (%swift.function, %swift.function* @"$s5block6incremSiycvp", i32 0, i32 1), align 8
  ret i32 0
}

define hidden swiftcc { i8*, %swift.refcounted* } @"$s5block15makeIncrementerSiycyF"() #0 {
entry:
  %runningTotal.debug = alloca %TSi*, align 8
  %0 = bitcast %TSi** %runningTotal.debug to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %0, i8 0, i64 8, i1 false)
// %1堆空间的内存地址
  %1 = call noalias %swift.refcounted* @swift_allocObject(%swift.type* getelementptr inbounds (%swift.full_boxmetadata, %swift.full_boxmetadata* @metadata, i32 0, i32 2), i64 24, i64 7) #1
// 做了一个指针类型的转换，相当于UnsafeBitcast
  %2 = bitcast %swift.refcounted* %1 to <{ %swift.refcounted, [8 x i8] }>*
// 取出指向[8 x i8]的指针
  %3 = getelementptr inbounds <{ %swift.refcounted, [8 x i8] }>, <{ %swift.refcounted, [8 x i8] }>* %2, i32 0, i32 1
// 把它转换成 %TSi* 类型  （%TSi* 其实是一个 type<{ i64 }>   64位的结构体）
  %4 = bitcast [8 x i8]* %3 to %TSi*
// 存储
  store %TSi* %4, %TSi** %runningTotal.debug, align 8
//取出%4也就是%TSi* 类型的地址
  %._value = getelementptr inbounds %TSi, %TSi* %4, i32 0, i32 0
// 把10这个值放到%._value偏移8字节的内存空间里，也就是type<{ i64 }>，往下偏移8字节，即swift.refcounted
  store i64 10, i64* %._value, align 8
// 将func里的内嵌闭包地址转换成 void * 插入到 { i8*, %swift.refcounted* } 的第一个元素，第二个元素是%1
  %5 = insertvalue { i8*, %swift.refcounted* } { i8* bitcast (i64 (%swift.refcounted*)* @"$s5block15makeIncrementerSiycyF11incrementerL_SiyFTA" to i8*), %swift.refcounted* undef }, %swift.refcounted* %1, 1
  ret { i8*, %swift.refcounted* } %5
}

define private swiftcc void @objectdestroy(%swift.refcounted* swiftself %0) #0 {
entry:
  %1 = bitcast %swift.refcounted* %0 to <{ %swift.refcounted, [8 x i8] }>*
  call void @swift_deallocObject(%swift.refcounted* %0, i64 24, i64 7) #1
  ret void
}

; Function Attrs: nounwind
declare void @swift_deallocObject(%swift.refcounted*, i64, i64) #1

; Function Attrs: nounwind
declare %swift.refcounted* @swift_allocObject(%swift.type*, i64, i64) #1

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

define internal swiftcc i64 @"$s5block15makeIncrementerSiycyF11incrementerL_SiyF"(%swift.refcounted* %0) #0 {
entry:
  %runningTotal.debug = alloca %TSi*, align 8
  %1 = bitcast %TSi** %runningTotal.debug to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %1, i8 0, i64 8, i1 false)
  %access-scratch = alloca [24 x i8], align 8
  %access-scratch2 = alloca [24 x i8], align 8
  %2 = bitcast %swift.refcounted* %0 to <{ %swift.refcounted, [8 x i8] }>*
  %3 = getelementptr inbounds <{ %swift.refcounted, [8 x i8] }>, <{ %swift.refcounted, [8 x i8] }>* %2, i32 0, i32 1
  %4 = bitcast [8 x i8]* %3 to %TSi*
  store %TSi* %4, %TSi** %runningTotal.debug, align 8
  %5 = bitcast [24 x i8]* %access-scratch to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %5)
  %6 = bitcast %TSi* %4 to i8*
  call void @swift_beginAccess(i8* %6, [24 x i8]* %access-scratch, i64 33, i8* null) #1
  %._value = getelementptr inbounds %TSi, %TSi* %4, i32 0, i32 0
  %7 = load i64, i64* %._value, align 8
  %8 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %7, i64 2)
  %9 = extractvalue { i64, i1 } %8, 0
  %10 = extractvalue { i64, i1 } %8, 1
  %11 = call i1 @llvm.expect.i1(i1 %10, i1 false)
  br i1 %11, label %18, label %12

12:                                               ; preds = %entry
  %._value1 = getelementptr inbounds %TSi, %TSi* %4, i32 0, i32 0
  store i64 %9, i64* %._value1, align 8
  call void @swift_endAccess([24 x i8]* %access-scratch) #1
  %13 = bitcast [24 x i8]* %access-scratch to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %13)
  %14 = bitcast [24 x i8]* %access-scratch2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %14)
  %15 = bitcast %TSi* %4 to i8*
  call void @swift_beginAccess(i8* %15, [24 x i8]* %access-scratch2, i64 32, i8* null) #1
  %._value3 = getelementptr inbounds %TSi, %TSi* %4, i32 0, i32 0
  %16 = load i64, i64* %._value3, align 8
  call void @swift_endAccess([24 x i8]* %access-scratch2) #1
  %17 = bitcast [24 x i8]* %access-scratch2 to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %17)
  ret i64 %16

18:                                               ; preds = %entry
  call void @llvm.trap()
  unreachable
}

define internal swiftcc i64 @"$s5block15makeIncrementerSiycyF11incrementerL_SiyFTA"(%swift.refcounted* swiftself %0) #0 {
entry:
  %1 = tail call swiftcc i64 @"$s5block15makeIncrementerSiycyF11incrementerL_SiyF"(%swift.refcounted* %0)
  ret i64 %1
}

; Function Attrs: argmemonly nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #3

; Function Attrs: nounwind
declare void @swift_beginAccess(i8*, [24 x i8]*, i64, i8*) #1

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64) #4

; Function Attrs: nocallback nofree nosync nounwind readnone willreturn
declare i1 @llvm.expect.i1(i1, i1) #5

; Function Attrs: cold noreturn nounwind
declare void @llvm.trap() #6

; Function Attrs: nounwind
declare void @swift_endAccess([24 x i8]*) #1

; Function Attrs: argmemonly nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #3

attributes #0 = { "frame-pointer"="all" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind }
attributes #2 = { argmemonly nofree nounwind willreturn writeonly }
attributes #3 = { argmemonly nocallback nofree nosync nounwind willreturn }
attributes #4 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #5 = { nocallback nofree nosync nounwind readnone willreturn }
attributes #6 = { cold noreturn nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4, !5, !6, !7, !8, !9, !10, !11}
!swift.module.flags = !{!12}
!llvm.asan.globals = !{!13, !14}
!llvm.linker.options = !{!15, !16, !17, !18, !19}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 13, i32 3]}
!1 = !{i32 1, !"Objective-C Version", i32 2}
!2 = !{i32 1, !"Objective-C Image Info Version", i32 0}
!3 = !{i32 1, !"Objective-C Image Info Section", !"__DATA,__objc_imageinfo,regular,no_dead_strip"}
!4 = !{i32 4, !"Objective-C Garbage Collection", i32 84412160}
!5 = !{i32 1, !"Objective-C Class Properties", i32 64}
!6 = !{i32 1, !"Objective-C Enforce ClassRO Pointer Signing", i8 0}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{i32 7, !"PIC Level", i32 2}
!9 = !{i32 7, !"uwtable", i32 2}
!10 = !{i32 7, !"frame-pointer", i32 2}
!11 = !{i32 1, !"Swift Version", i32 7}
!12 = !{!"standard-library", i1 false}
!13 = !{<{ [2 x i8], i8 }>* @"symbolic Si", null, null, i1 false, i1 true}
!14 = !{{ i32, i32, i32, i32 }* @"\01l__swift5_reflection_descriptor", null, null, i1 false, i1 true}
!15 = !{!"-lswiftSwiftOnoneSupport"}
!16 = !{!"-lswiftCore"}
!17 = !{!"-lswift_Concurrency"}
!18 = !{!"-lswift_StringProcessing"}
!19 = !{!"-lobjc"}
