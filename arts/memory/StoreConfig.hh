//
// This File is generated. Please do not edit.
//
#ifndef __STORECONFIG_HH__
#define __STORECONFIG_HH__

typedef enum {
  GEN_GC_SHIFT     = 0x0,
  SIZESHIFT_SHIFT  = 0x2,
  SIZE_SHIFT       = 0x3,
  TAG_SHIFT        = 0x37,
  MUTABLE_SHIFT    = 0x3e,
  CHILDISH_SHIFT   = 0x3f,
  MAX_TAGSIZE      = 0x7f,
  MAX_BLOCKSIZE    = 0xfffff,
  MAX_BIGBLOCKSIZE = 0xfffff0,
  MAX_DYNBLOCKSIZE = 0xffffef,
  BIGSIZE_MIN      = 0x10,
  GEN_GC_MASK      = 0x3,
  SIZESHIFT_MASK   = 0x4,
  SIZE_MASK        = 0x7ffffffffffff8,
  TAG_MASK         = 0x3f80000000000000,
  MUTABLE_MASK     = 0x4000000000000000,
  CHILDISH_MASK    = 0x8000000000000000,
} HeaderWord;

typedef enum {
  MIN_DATA_LABEL      = 0x0,
  MAX_DATA_LABEL      = 0x64,
  MIN_HELPER_LABEL    = 0x65,

  GENSET_LABEL = 0x65,
  INT_MAP_LABEL = 0x66,
  CHUNK_MAP_LABEL = 0x67,
  MAP_LABEL = 0x68,
  HASHNODEARRAY_LABEL = 0x69,
  HASHNODE_LABEL = 0x6a,
  QUEUE_LABEL = 0x6b,
  STACK_LABEL = 0x6c,
  ROOTSETELEMENT_LABEL = 0x6d,
  UNIQUESTRING_LABEL = 0x6e,
  THREAD_LABEL = 0x6f,
  TASKSTACK_LABEL = 0x70,
  CLOSURE_LABEL = 0x71,
  TUPLE_LABEL = 0x72,
  CONCRETE_LABEL = 0x73,
  TRANSFORM_LABEL = 0x74,
  ARGS_LABEL = 0x75,
  IODESC_LABEL = 0x76,
  DEBUG_ENVIRONMENT_LABEL = 0x77,

  MAX_HELPER_LABEL    = 0x77,
  MIN_STORE_LABEL     = 0x78,
  MIN_TRANSIENT_LABEL = 0x78,
  HOLE_LABEL          = 0x78,
  FUTURE_LABEL        = 0x79,
  REF_LABEL           = 0x7a,
  CANCELLED_LABEL     = 0x7b,
  BYNEED_LABEL        = 0x7c,
  MAX_TRANSIENT_LABEL = 0x7c,
  CHUNK_LABEL         = 0x7d,
  WEAK_MAP_LABEL      = 0x7e,
  DYNAMIC_LABEL       = 0x7f,
  MAX_STORE_LABEL     = 0x7f
} BlockLabel;

#define STORE_GENERATION_NUM 4
#define STORE_GEN_YOUNGEST   0
#define STORE_GEN_OLDEST     2
#define STORE_MEM_ALIGN      8
#define STORE_MEMCHUNK_SIZE  131072
#define STORE_INTGENSET_SIZE 1024
#define STORE_WKDICTSET_SIZE 256
#define STORE_WORD_WIDTH     64

typedef long s_int;
#ifndef HAVE_U_INT
#define u_int unsigned long
#define u_char unsigned char

#else
#include <sys/types.h>
#endif
#define FLOAT_BIG_ENDIAN 0
#define FLOAT_LITTLE_ENDIAN 1

#define DOUBLE_BIG_ENDIAN 0
#define DOUBLE_LITTLE_ENDIAN 1

#define DOUBLE_ARM_ENDIAN 0

#endif
