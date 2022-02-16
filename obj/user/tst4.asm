
obj/user/tst4:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 a9 08 00 00       	call   8008df <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	

	rsttst();
  800044:	e8 9c 21 00 00       	call   8021e5 <rsttst>
	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  800049:	83 ec 0c             	sub    $0xc,%esp
  80004c:	6a 03                	push   $0x3
  80004e:	e8 6c 21 00 00       	call   8021bf <sys_bypassPageFault>
  800053:	83 c4 10             	add    $0x10,%esp


	
	

	int Mega = 1024*1024;
  800056:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  80005d:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  800064:	e8 3f 1e 00 00       	call   801ea8 <sys_calculate_free_frames>
  800069:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//ALLOCATE ALL
	void* ptr_allocations[20] = {0};
  80006c:	8d 55 80             	lea    -0x80(%ebp),%edx
  80006f:	b9 14 00 00 00       	mov    $0x14,%ecx
  800074:	b8 00 00 00 00       	mov    $0x0,%eax
  800079:	89 d7                	mov    %edx,%edi
  80007b:	f3 ab                	rep stos %eax,%es:(%edi)
	int lastIndices[20] = {0};
  80007d:	8d 95 30 ff ff ff    	lea    -0xd0(%ebp),%edx
  800083:	b9 14 00 00 00       	mov    $0x14,%ecx
  800088:	b8 00 00 00 00       	mov    $0x0,%eax
  80008d:	89 d7                	mov    %edx,%edi
  80008f:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  800091:	e8 12 1e 00 00       	call   801ea8 <sys_calculate_free_frames>
  800096:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800099:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80009c:	01 c0                	add    %eax,%eax
  80009e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	50                   	push   %eax
  8000a5:	e8 d8 17 00 00       	call   801882 <malloc>
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	89 45 80             	mov    %eax,-0x80(%ebp)
		tst((uint32) ptr_allocations[0], USER_HEAP_START,USER_HEAP_START + PAGE_SIZE, 'b', 0);
  8000b0:	8b 45 80             	mov    -0x80(%ebp),%eax
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	6a 00                	push   $0x0
  8000b8:	6a 62                	push   $0x62
  8000ba:	68 00 10 00 80       	push   $0x80001000
  8000bf:	68 00 00 00 80       	push   $0x80000000
  8000c4:	50                   	push   %eax
  8000c5:	e8 35 21 00 00       	call   8021ff <tst>
  8000ca:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512+1 ,0, 'e', 0);
  8000cd:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8000d0:	e8 d3 1d 00 00       	call   801ea8 <sys_calculate_free_frames>
  8000d5:	29 c3                	sub    %eax,%ebx
  8000d7:	89 d8                	mov    %ebx,%eax
  8000d9:	83 ec 0c             	sub    $0xc,%esp
  8000dc:	6a 00                	push   $0x0
  8000de:	6a 65                	push   $0x65
  8000e0:	6a 00                	push   $0x0
  8000e2:	68 01 02 00 00       	push   $0x201
  8000e7:	50                   	push   %eax
  8000e8:	e8 12 21 00 00       	call   8021ff <tst>
  8000ed:	83 c4 20             	add    $0x20,%esp
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  8000f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f3:	01 c0                	add    %eax,%eax
  8000f5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8000f8:	48                   	dec    %eax
  8000f9:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8000ff:	e8 a4 1d 00 00       	call   801ea8 <sys_calculate_free_frames>
  800104:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800107:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80010a:	01 c0                	add    %eax,%eax
  80010c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	50                   	push   %eax
  800113:	e8 6a 17 00 00       	call   801882 <malloc>
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	89 45 84             	mov    %eax,-0x7c(%ebp)
		tst((uint32) ptr_allocations[1], USER_HEAP_START+ 2*Mega,USER_HEAP_START + 2*Mega + PAGE_SIZE, 'b', 0);
  80011e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800121:	01 c0                	add    %eax,%eax
  800123:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012c:	01 c0                	add    %eax,%eax
  80012e:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800134:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	6a 00                	push   $0x0
  80013c:	6a 62                	push   $0x62
  80013e:	51                   	push   %ecx
  80013f:	52                   	push   %edx
  800140:	50                   	push   %eax
  800141:	e8 b9 20 00 00       	call   8021ff <tst>
  800146:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512 ,0, 'e', 0);
  800149:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  80014c:	e8 57 1d 00 00       	call   801ea8 <sys_calculate_free_frames>
  800151:	29 c3                	sub    %eax,%ebx
  800153:	89 d8                	mov    %ebx,%eax
  800155:	83 ec 0c             	sub    $0xc,%esp
  800158:	6a 00                	push   $0x0
  80015a:	6a 65                	push   $0x65
  80015c:	6a 00                	push   $0x0
  80015e:	68 00 02 00 00       	push   $0x200
  800163:	50                   	push   %eax
  800164:	e8 96 20 00 00       	call   8021ff <tst>
  800169:	83 c4 20             	add    $0x20,%esp
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  80016c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016f:	01 c0                	add    %eax,%eax
  800171:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800174:	48                   	dec    %eax
  800175:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)


		freeFrames = sys_calculate_free_frames() ;
  80017b:	e8 28 1d 00 00       	call   801ea8 <sys_calculate_free_frames>
  800180:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800183:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800186:	01 c0                	add    %eax,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	50                   	push   %eax
  80018c:	e8 f1 16 00 00       	call   801882 <malloc>
  800191:	83 c4 10             	add    $0x10,%esp
  800194:	89 45 88             	mov    %eax,-0x78(%ebp)
		tst((uint32) ptr_allocations[2], USER_HEAP_START+ 4*Mega,USER_HEAP_START + 4*Mega + PAGE_SIZE, 'b', 0);
  800197:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80019a:	c1 e0 02             	shl    $0x2,%eax
  80019d:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8001a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a6:	c1 e0 02             	shl    $0x2,%eax
  8001a9:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8001af:	8b 45 88             	mov    -0x78(%ebp),%eax
  8001b2:	83 ec 0c             	sub    $0xc,%esp
  8001b5:	6a 00                	push   $0x0
  8001b7:	6a 62                	push   $0x62
  8001b9:	51                   	push   %ecx
  8001ba:	52                   	push   %edx
  8001bb:	50                   	push   %eax
  8001bc:	e8 3e 20 00 00       	call   8021ff <tst>
  8001c1:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 1+1 ,0, 'e', 0);
  8001c4:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8001c7:	e8 dc 1c 00 00       	call   801ea8 <sys_calculate_free_frames>
  8001cc:	29 c3                	sub    %eax,%ebx
  8001ce:	89 d8                	mov    %ebx,%eax
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	6a 00                	push   $0x0
  8001d5:	6a 65                	push   $0x65
  8001d7:	6a 00                	push   $0x0
  8001d9:	6a 02                	push   $0x2
  8001db:	50                   	push   %eax
  8001dc:	e8 1e 20 00 00       	call   8021ff <tst>
  8001e1:	83 c4 20             	add    $0x20,%esp
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  8001e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e7:	01 c0                	add    %eax,%eax
  8001e9:	48                   	dec    %eax
  8001ea:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)


		freeFrames = sys_calculate_free_frames() ;
  8001f0:	e8 b3 1c 00 00       	call   801ea8 <sys_calculate_free_frames>
  8001f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  8001f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001fb:	01 c0                	add    %eax,%eax
  8001fd:	83 ec 0c             	sub    $0xc,%esp
  800200:	50                   	push   %eax
  800201:	e8 7c 16 00 00       	call   801882 <malloc>
  800206:	83 c4 10             	add    $0x10,%esp
  800209:	89 45 8c             	mov    %eax,-0x74(%ebp)
		tst((uint32) ptr_allocations[3], USER_HEAP_START+ 4*Mega + 4*kilo,USER_HEAP_START + 4*Mega + 4*kilo + PAGE_SIZE, 'b', 0);
  80020c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80020f:	c1 e0 02             	shl    $0x2,%eax
  800212:	89 c2                	mov    %eax,%edx
  800214:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800217:	c1 e0 02             	shl    $0x2,%eax
  80021a:	01 d0                	add    %edx,%eax
  80021c:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800222:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800225:	c1 e0 02             	shl    $0x2,%eax
  800228:	89 c2                	mov    %eax,%edx
  80022a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022d:	c1 e0 02             	shl    $0x2,%eax
  800230:	01 d0                	add    %edx,%eax
  800232:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800238:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	6a 00                	push   $0x0
  800240:	6a 62                	push   $0x62
  800242:	51                   	push   %ecx
  800243:	52                   	push   %edx
  800244:	50                   	push   %eax
  800245:	e8 b5 1f 00 00       	call   8021ff <tst>
  80024a:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 1 ,0, 'e', 0);
  80024d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800250:	e8 53 1c 00 00       	call   801ea8 <sys_calculate_free_frames>
  800255:	29 c3                	sub    %eax,%ebx
  800257:	89 d8                	mov    %ebx,%eax
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	6a 00                	push   $0x0
  80025e:	6a 65                	push   $0x65
  800260:	6a 00                	push   $0x0
  800262:	6a 01                	push   $0x1
  800264:	50                   	push   %eax
  800265:	e8 95 1f 00 00       	call   8021ff <tst>
  80026a:	83 c4 20             	add    $0x20,%esp
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  80026d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800270:	01 c0                	add    %eax,%eax
  800272:	48                   	dec    %eax
  800273:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)


		freeFrames = sys_calculate_free_frames() ;
  800279:	e8 2a 1c 00 00       	call   801ea8 <sys_calculate_free_frames>
  80027e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800281:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800284:	89 d0                	mov    %edx,%eax
  800286:	01 c0                	add    %eax,%eax
  800288:	01 d0                	add    %edx,%eax
  80028a:	01 c0                	add    %eax,%eax
  80028c:	01 d0                	add    %edx,%eax
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	e8 eb 15 00 00       	call   801882 <malloc>
  800297:	83 c4 10             	add    $0x10,%esp
  80029a:	89 45 90             	mov    %eax,-0x70(%ebp)
		tst((uint32) ptr_allocations[4], USER_HEAP_START+ 4*Mega + 8*kilo,USER_HEAP_START + 4*Mega + 8*kilo + PAGE_SIZE, 'b', 0);
  80029d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a0:	c1 e0 02             	shl    $0x2,%eax
  8002a3:	89 c2                	mov    %eax,%edx
  8002a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002a8:	c1 e0 03             	shl    $0x3,%eax
  8002ab:	01 d0                	add    %edx,%eax
  8002ad:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8002b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b6:	c1 e0 02             	shl    $0x2,%eax
  8002b9:	89 c2                	mov    %eax,%edx
  8002bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002be:	c1 e0 03             	shl    $0x3,%eax
  8002c1:	01 d0                	add    %edx,%eax
  8002c3:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8002c9:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002cc:	83 ec 0c             	sub    $0xc,%esp
  8002cf:	6a 00                	push   $0x0
  8002d1:	6a 62                	push   $0x62
  8002d3:	51                   	push   %ecx
  8002d4:	52                   	push   %edx
  8002d5:	50                   	push   %eax
  8002d6:	e8 24 1f 00 00       	call   8021ff <tst>
  8002db:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 2 ,0, 'e', 0);
  8002de:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8002e1:	e8 c2 1b 00 00       	call   801ea8 <sys_calculate_free_frames>
  8002e6:	29 c3                	sub    %eax,%ebx
  8002e8:	89 d8                	mov    %ebx,%eax
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	6a 00                	push   $0x0
  8002ef:	6a 65                	push   $0x65
  8002f1:	6a 00                	push   $0x0
  8002f3:	6a 02                	push   $0x2
  8002f5:	50                   	push   %eax
  8002f6:	e8 04 1f 00 00       	call   8021ff <tst>
  8002fb:	83 c4 20             	add    $0x20,%esp
		lastIndices[4] = (7*kilo)/sizeof(char) - 1;
  8002fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800301:	89 d0                	mov    %edx,%eax
  800303:	01 c0                	add    %eax,%eax
  800305:	01 d0                	add    %edx,%eax
  800307:	01 c0                	add    %eax,%eax
  800309:	01 d0                	add    %edx,%eax
  80030b:	48                   	dec    %eax
  80030c:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)


		freeFrames = sys_calculate_free_frames() ;
  800312:	e8 91 1b 00 00       	call   801ea8 <sys_calculate_free_frames>
  800317:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  80031a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031d:	89 c2                	mov    %eax,%edx
  80031f:	01 d2                	add    %edx,%edx
  800321:	01 d0                	add    %edx,%eax
  800323:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800326:	83 ec 0c             	sub    $0xc,%esp
  800329:	50                   	push   %eax
  80032a:	e8 53 15 00 00       	call   801882 <malloc>
  80032f:	83 c4 10             	add    $0x10,%esp
  800332:	89 45 94             	mov    %eax,-0x6c(%ebp)
		tst((uint32) ptr_allocations[5], USER_HEAP_START+ 4*Mega + 16*kilo,USER_HEAP_START + 4*Mega + 16*kilo + PAGE_SIZE, 'b', 0);
  800335:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800338:	c1 e0 02             	shl    $0x2,%eax
  80033b:	89 c2                	mov    %eax,%edx
  80033d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800340:	c1 e0 04             	shl    $0x4,%eax
  800343:	01 d0                	add    %edx,%eax
  800345:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  80034b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80034e:	c1 e0 02             	shl    $0x2,%eax
  800351:	89 c2                	mov    %eax,%edx
  800353:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800356:	c1 e0 04             	shl    $0x4,%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800361:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800364:	83 ec 0c             	sub    $0xc,%esp
  800367:	6a 00                	push   $0x0
  800369:	6a 62                	push   $0x62
  80036b:	51                   	push   %ecx
  80036c:	52                   	push   %edx
  80036d:	50                   	push   %eax
  80036e:	e8 8c 1e 00 00       	call   8021ff <tst>
  800373:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 3*Mega/4096 ,0, 'e', 0);
  800376:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800379:	89 c2                	mov    %eax,%edx
  80037b:	01 d2                	add    %edx,%edx
  80037d:	01 d0                	add    %edx,%eax
  80037f:	85 c0                	test   %eax,%eax
  800381:	79 05                	jns    800388 <_main+0x350>
  800383:	05 ff 0f 00 00       	add    $0xfff,%eax
  800388:	c1 f8 0c             	sar    $0xc,%eax
  80038b:	89 c3                	mov    %eax,%ebx
  80038d:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800390:	e8 13 1b 00 00       	call   801ea8 <sys_calculate_free_frames>
  800395:	29 c6                	sub    %eax,%esi
  800397:	89 f0                	mov    %esi,%eax
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	6a 00                	push   $0x0
  80039e:	6a 65                	push   $0x65
  8003a0:	6a 00                	push   $0x0
  8003a2:	53                   	push   %ebx
  8003a3:	50                   	push   %eax
  8003a4:	e8 56 1e 00 00       	call   8021ff <tst>
  8003a9:	83 c4 20             	add    $0x20,%esp
		lastIndices[5] = (3*Mega - kilo)/sizeof(char) - 1;
  8003ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003af:	89 c2                	mov    %eax,%edx
  8003b1:	01 d2                	add    %edx,%edx
  8003b3:	01 d0                	add    %edx,%eax
  8003b5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8003b8:	48                   	dec    %eax
  8003b9:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)


		freeFrames = sys_calculate_free_frames() ;
  8003bf:	e8 e4 1a 00 00       	call   801ea8 <sys_calculate_free_frames>
  8003c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  8003c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ca:	01 c0                	add    %eax,%eax
  8003cc:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8003cf:	83 ec 0c             	sub    $0xc,%esp
  8003d2:	50                   	push   %eax
  8003d3:	e8 aa 14 00 00       	call   801882 <malloc>
  8003d8:	83 c4 10             	add    $0x10,%esp
  8003db:	89 45 98             	mov    %eax,-0x68(%ebp)
		tst((uint32) ptr_allocations[6], USER_HEAP_START+ 7*Mega + 16*kilo,USER_HEAP_START + 7*Mega + 16*kilo + PAGE_SIZE, 'b', 0);
  8003de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003e1:	89 d0                	mov    %edx,%eax
  8003e3:	01 c0                	add    %eax,%eax
  8003e5:	01 d0                	add    %edx,%eax
  8003e7:	01 c0                	add    %eax,%eax
  8003e9:	01 d0                	add    %edx,%eax
  8003eb:	89 c2                	mov    %eax,%edx
  8003ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f0:	c1 e0 04             	shl    $0x4,%eax
  8003f3:	01 d0                	add    %edx,%eax
  8003f5:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8003fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003fe:	89 d0                	mov    %edx,%eax
  800400:	01 c0                	add    %eax,%eax
  800402:	01 d0                	add    %edx,%eax
  800404:	01 c0                	add    %eax,%eax
  800406:	01 d0                	add    %edx,%eax
  800408:	89 c2                	mov    %eax,%edx
  80040a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80040d:	c1 e0 04             	shl    $0x4,%eax
  800410:	01 d0                	add    %edx,%eax
  800412:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800418:	8b 45 98             	mov    -0x68(%ebp),%eax
  80041b:	83 ec 0c             	sub    $0xc,%esp
  80041e:	6a 00                	push   $0x0
  800420:	6a 62                	push   $0x62
  800422:	51                   	push   %ecx
  800423:	52                   	push   %edx
  800424:	50                   	push   %eax
  800425:	e8 d5 1d 00 00       	call   8021ff <tst>
  80042a:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512+1 ,0, 'e', 0);
  80042d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800430:	e8 73 1a 00 00       	call   801ea8 <sys_calculate_free_frames>
  800435:	29 c3                	sub    %eax,%ebx
  800437:	89 d8                	mov    %ebx,%eax
  800439:	83 ec 0c             	sub    $0xc,%esp
  80043c:	6a 00                	push   $0x0
  80043e:	6a 65                	push   $0x65
  800440:	6a 00                	push   $0x0
  800442:	68 01 02 00 00       	push   $0x201
  800447:	50                   	push   %eax
  800448:	e8 b2 1d 00 00       	call   8021ff <tst>
  80044d:	83 c4 20             	add    $0x20,%esp
		lastIndices[6] = (2*Mega - kilo)/sizeof(char) - 1;
  800450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800453:	01 c0                	add    %eax,%eax
  800455:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800458:	48                   	dec    %eax
  800459:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	char x ;
	int y;
	char *byteArr ;
	//FREE ALL
	{
		int freeFrames = sys_calculate_free_frames() ;
  80045f:	e8 44 1a 00 00       	call   801ea8 <sys_calculate_free_frames>
  800464:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  800467:	8b 45 80             	mov    -0x80(%ebp),%eax
  80046a:	83 ec 0c             	sub    $0xc,%esp
  80046d:	50                   	push   %eax
  80046e:	e8 dc 16 00 00       	call   801b4f <free>
  800473:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 512 ,0, 'e', 0);
  800476:	e8 2d 1a 00 00       	call   801ea8 <sys_calculate_free_frames>
  80047b:	89 c2                	mov    %eax,%edx
  80047d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800480:	29 c2                	sub    %eax,%edx
  800482:	89 d0                	mov    %edx,%eax
  800484:	83 ec 0c             	sub    $0xc,%esp
  800487:	6a 00                	push   $0x0
  800489:	6a 65                	push   $0x65
  80048b:	6a 00                	push   $0x0
  80048d:	68 00 02 00 00       	push   $0x200
  800492:	50                   	push   %eax
  800493:	e8 67 1d 00 00       	call   8021ff <tst>
  800498:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[0];
  80049b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80049e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8004a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004a4:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  8004a7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8004aa:	e8 f7 1c 00 00       	call   8021a6 <sys_rcr2>
  8004af:	83 ec 0c             	sub    $0xc,%esp
  8004b2:	6a 00                	push   $0x0
  8004b4:	6a 65                	push   $0x65
  8004b6:	6a 00                	push   $0x0
  8004b8:	53                   	push   %ebx
  8004b9:	50                   	push   %eax
  8004ba:	e8 40 1d 00 00       	call   8021ff <tst>
  8004bf:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[0]] = 10;
  8004c2:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004c8:	89 c2                	mov    %eax,%edx
  8004ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004cd:	01 d0                	add    %edx,%eax
  8004cf:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[0]]) ,0, 'e', 0);
  8004d2:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004d8:	89 c2                	mov    %eax,%edx
  8004da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004dd:	01 d0                	add    %edx,%eax
  8004df:	89 c3                	mov    %eax,%ebx
  8004e1:	e8 c0 1c 00 00       	call   8021a6 <sys_rcr2>
  8004e6:	83 ec 0c             	sub    $0xc,%esp
  8004e9:	6a 00                	push   $0x0
  8004eb:	6a 65                	push   $0x65
  8004ed:	6a 00                	push   $0x0
  8004ef:	53                   	push   %ebx
  8004f0:	50                   	push   %eax
  8004f1:	e8 09 1d 00 00       	call   8021ff <tst>
  8004f6:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  8004f9:	e8 aa 19 00 00       	call   801ea8 <sys_calculate_free_frames>
  8004fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  800501:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	50                   	push   %eax
  800508:	e8 42 16 00 00       	call   801b4f <free>
  80050d:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 512 +1,0, 'e', 0);
  800510:	e8 93 19 00 00       	call   801ea8 <sys_calculate_free_frames>
  800515:	89 c2                	mov    %eax,%edx
  800517:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80051a:	29 c2                	sub    %eax,%edx
  80051c:	89 d0                	mov    %edx,%eax
  80051e:	83 ec 0c             	sub    $0xc,%esp
  800521:	6a 00                	push   $0x0
  800523:	6a 65                	push   $0x65
  800525:	6a 00                	push   $0x0
  800527:	68 01 02 00 00       	push   $0x201
  80052c:	50                   	push   %eax
  80052d:	e8 cd 1c 00 00       	call   8021ff <tst>
  800532:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[1];
  800535:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800538:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80053b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80053e:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  800541:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800544:	e8 5d 1c 00 00       	call   8021a6 <sys_rcr2>
  800549:	83 ec 0c             	sub    $0xc,%esp
  80054c:	6a 00                	push   $0x0
  80054e:	6a 65                	push   $0x65
  800550:	6a 00                	push   $0x0
  800552:	53                   	push   %ebx
  800553:	50                   	push   %eax
  800554:	e8 a6 1c 00 00       	call   8021ff <tst>
  800559:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[1]] = 10;
  80055c:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800562:	89 c2                	mov    %eax,%edx
  800564:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800567:	01 d0                	add    %edx,%eax
  800569:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[1]]) ,0, 'e', 0);
  80056c:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800572:	89 c2                	mov    %eax,%edx
  800574:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800577:	01 d0                	add    %edx,%eax
  800579:	89 c3                	mov    %eax,%ebx
  80057b:	e8 26 1c 00 00       	call   8021a6 <sys_rcr2>
  800580:	83 ec 0c             	sub    $0xc,%esp
  800583:	6a 00                	push   $0x0
  800585:	6a 65                	push   $0x65
  800587:	6a 00                	push   $0x0
  800589:	53                   	push   %ebx
  80058a:	50                   	push   %eax
  80058b:	e8 6f 1c 00 00       	call   8021ff <tst>
  800590:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  800593:	e8 10 19 00 00       	call   801ea8 <sys_calculate_free_frames>
  800598:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  80059b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	e8 a8 15 00 00       	call   801b4f <free>
  8005a7:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 1 ,0, 'e', 0);
  8005aa:	e8 f9 18 00 00       	call   801ea8 <sys_calculate_free_frames>
  8005af:	89 c2                	mov    %eax,%edx
  8005b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b4:	29 c2                	sub    %eax,%edx
  8005b6:	89 d0                	mov    %edx,%eax
  8005b8:	83 ec 0c             	sub    $0xc,%esp
  8005bb:	6a 00                	push   $0x0
  8005bd:	6a 65                	push   $0x65
  8005bf:	6a 00                	push   $0x0
  8005c1:	6a 01                	push   $0x1
  8005c3:	50                   	push   %eax
  8005c4:	e8 36 1c 00 00       	call   8021ff <tst>
  8005c9:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[2];
  8005cc:	8b 45 88             	mov    -0x78(%ebp),%eax
  8005cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8005d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005d5:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  8005d8:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8005db:	e8 c6 1b 00 00       	call   8021a6 <sys_rcr2>
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	6a 00                	push   $0x0
  8005e5:	6a 65                	push   $0x65
  8005e7:	6a 00                	push   $0x0
  8005e9:	53                   	push   %ebx
  8005ea:	50                   	push   %eax
  8005eb:	e8 0f 1c 00 00       	call   8021ff <tst>
  8005f0:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[2]] = 10;
  8005f3:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  8005f9:	89 c2                	mov    %eax,%edx
  8005fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005fe:	01 d0                	add    %edx,%eax
  800600:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[2]]) ,0, 'e', 0);
  800603:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800609:	89 c2                	mov    %eax,%edx
  80060b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80060e:	01 d0                	add    %edx,%eax
  800610:	89 c3                	mov    %eax,%ebx
  800612:	e8 8f 1b 00 00       	call   8021a6 <sys_rcr2>
  800617:	83 ec 0c             	sub    $0xc,%esp
  80061a:	6a 00                	push   $0x0
  80061c:	6a 65                	push   $0x65
  80061e:	6a 00                	push   $0x0
  800620:	53                   	push   %ebx
  800621:	50                   	push   %eax
  800622:	e8 d8 1b 00 00       	call   8021ff <tst>
  800627:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  80062a:	e8 79 18 00 00       	call   801ea8 <sys_calculate_free_frames>
  80062f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  800632:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800635:	83 ec 0c             	sub    $0xc,%esp
  800638:	50                   	push   %eax
  800639:	e8 11 15 00 00       	call   801b4f <free>
  80063e:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 1 ,0, 'e', 0);
  800641:	e8 62 18 00 00       	call   801ea8 <sys_calculate_free_frames>
  800646:	89 c2                	mov    %eax,%edx
  800648:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80064b:	29 c2                	sub    %eax,%edx
  80064d:	89 d0                	mov    %edx,%eax
  80064f:	83 ec 0c             	sub    $0xc,%esp
  800652:	6a 00                	push   $0x0
  800654:	6a 65                	push   $0x65
  800656:	6a 00                	push   $0x0
  800658:	6a 01                	push   $0x1
  80065a:	50                   	push   %eax
  80065b:	e8 9f 1b 00 00       	call   8021ff <tst>
  800660:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[3];
  800663:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800666:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800669:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80066c:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  80066f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800672:	e8 2f 1b 00 00       	call   8021a6 <sys_rcr2>
  800677:	83 ec 0c             	sub    $0xc,%esp
  80067a:	6a 00                	push   $0x0
  80067c:	6a 65                	push   $0x65
  80067e:	6a 00                	push   $0x0
  800680:	53                   	push   %ebx
  800681:	50                   	push   %eax
  800682:	e8 78 1b 00 00       	call   8021ff <tst>
  800687:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[3]] = 10;
  80068a:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800690:	89 c2                	mov    %eax,%edx
  800692:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800695:	01 d0                	add    %edx,%eax
  800697:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[3]]) ,0, 'e', 0);
  80069a:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8006a0:	89 c2                	mov    %eax,%edx
  8006a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006a5:	01 d0                	add    %edx,%eax
  8006a7:	89 c3                	mov    %eax,%ebx
  8006a9:	e8 f8 1a 00 00       	call   8021a6 <sys_rcr2>
  8006ae:	83 ec 0c             	sub    $0xc,%esp
  8006b1:	6a 00                	push   $0x0
  8006b3:	6a 65                	push   $0x65
  8006b5:	6a 00                	push   $0x0
  8006b7:	53                   	push   %ebx
  8006b8:	50                   	push   %eax
  8006b9:	e8 41 1b 00 00       	call   8021ff <tst>
  8006be:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  8006c1:	e8 e2 17 00 00       	call   801ea8 <sys_calculate_free_frames>
  8006c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  8006c9:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006cc:	83 ec 0c             	sub    $0xc,%esp
  8006cf:	50                   	push   %eax
  8006d0:	e8 7a 14 00 00       	call   801b4f <free>
  8006d5:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 2 ,0, 'e', 0);
  8006d8:	e8 cb 17 00 00       	call   801ea8 <sys_calculate_free_frames>
  8006dd:	89 c2                	mov    %eax,%edx
  8006df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e2:	29 c2                	sub    %eax,%edx
  8006e4:	89 d0                	mov    %edx,%eax
  8006e6:	83 ec 0c             	sub    $0xc,%esp
  8006e9:	6a 00                	push   $0x0
  8006eb:	6a 65                	push   $0x65
  8006ed:	6a 00                	push   $0x0
  8006ef:	6a 02                	push   $0x2
  8006f1:	50                   	push   %eax
  8006f2:	e8 08 1b 00 00       	call   8021ff <tst>
  8006f7:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[4];
  8006fa:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006fd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800700:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800703:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  800706:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800709:	e8 98 1a 00 00       	call   8021a6 <sys_rcr2>
  80070e:	83 ec 0c             	sub    $0xc,%esp
  800711:	6a 00                	push   $0x0
  800713:	6a 65                	push   $0x65
  800715:	6a 00                	push   $0x0
  800717:	53                   	push   %ebx
  800718:	50                   	push   %eax
  800719:	e8 e1 1a 00 00       	call   8021ff <tst>
  80071e:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[4]] = 10;
  800721:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800727:	89 c2                	mov    %eax,%edx
  800729:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80072c:	01 d0                	add    %edx,%eax
  80072e:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[4]]) ,0, 'e', 0);
  800731:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800737:	89 c2                	mov    %eax,%edx
  800739:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80073c:	01 d0                	add    %edx,%eax
  80073e:	89 c3                	mov    %eax,%ebx
  800740:	e8 61 1a 00 00       	call   8021a6 <sys_rcr2>
  800745:	83 ec 0c             	sub    $0xc,%esp
  800748:	6a 00                	push   $0x0
  80074a:	6a 65                	push   $0x65
  80074c:	6a 00                	push   $0x0
  80074e:	53                   	push   %ebx
  80074f:	50                   	push   %eax
  800750:	e8 aa 1a 00 00       	call   8021ff <tst>
  800755:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  800758:	e8 4b 17 00 00       	call   801ea8 <sys_calculate_free_frames>
  80075d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  800760:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800763:	83 ec 0c             	sub    $0xc,%esp
  800766:	50                   	push   %eax
  800767:	e8 e3 13 00 00       	call   801b4f <free>
  80076c:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 3*Mega/4096 ,0, 'e', 0);
  80076f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800772:	89 c2                	mov    %eax,%edx
  800774:	01 d2                	add    %edx,%edx
  800776:	01 d0                	add    %edx,%eax
  800778:	85 c0                	test   %eax,%eax
  80077a:	79 05                	jns    800781 <_main+0x749>
  80077c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800781:	c1 f8 0c             	sar    $0xc,%eax
  800784:	89 c3                	mov    %eax,%ebx
  800786:	e8 1d 17 00 00       	call   801ea8 <sys_calculate_free_frames>
  80078b:	89 c2                	mov    %eax,%edx
  80078d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800790:	29 c2                	sub    %eax,%edx
  800792:	89 d0                	mov    %edx,%eax
  800794:	83 ec 0c             	sub    $0xc,%esp
  800797:	6a 00                	push   $0x0
  800799:	6a 65                	push   $0x65
  80079b:	6a 00                	push   $0x0
  80079d:	53                   	push   %ebx
  80079e:	50                   	push   %eax
  80079f:	e8 5b 1a 00 00       	call   8021ff <tst>
  8007a4:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[5];
  8007a7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007aa:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8007ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007b0:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  8007b3:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8007b6:	e8 eb 19 00 00       	call   8021a6 <sys_rcr2>
  8007bb:	83 ec 0c             	sub    $0xc,%esp
  8007be:	6a 00                	push   $0x0
  8007c0:	6a 65                	push   $0x65
  8007c2:	6a 00                	push   $0x0
  8007c4:	53                   	push   %ebx
  8007c5:	50                   	push   %eax
  8007c6:	e8 34 1a 00 00       	call   8021ff <tst>
  8007cb:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[5]] = 10;
  8007ce:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  8007d4:	89 c2                	mov    %eax,%edx
  8007d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007d9:	01 d0                	add    %edx,%eax
  8007db:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[5]]) ,0, 'e', 0);
  8007de:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  8007e4:	89 c2                	mov    %eax,%edx
  8007e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007e9:	01 d0                	add    %edx,%eax
  8007eb:	89 c3                	mov    %eax,%ebx
  8007ed:	e8 b4 19 00 00       	call   8021a6 <sys_rcr2>
  8007f2:	83 ec 0c             	sub    $0xc,%esp
  8007f5:	6a 00                	push   $0x0
  8007f7:	6a 65                	push   $0x65
  8007f9:	6a 00                	push   $0x0
  8007fb:	53                   	push   %ebx
  8007fc:	50                   	push   %eax
  8007fd:	e8 fd 19 00 00       	call   8021ff <tst>
  800802:	83 c4 20             	add    $0x20,%esp

		freeFrames = sys_calculate_free_frames() ;
  800805:	e8 9e 16 00 00       	call   801ea8 <sys_calculate_free_frames>
  80080a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  80080d:	8b 45 98             	mov    -0x68(%ebp),%eax
  800810:	83 ec 0c             	sub    $0xc,%esp
  800813:	50                   	push   %eax
  800814:	e8 36 13 00 00       	call   801b4f <free>
  800819:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 512+2,0, 'e', 0);
  80081c:	e8 87 16 00 00       	call   801ea8 <sys_calculate_free_frames>
  800821:	89 c2                	mov    %eax,%edx
  800823:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800826:	29 c2                	sub    %eax,%edx
  800828:	89 d0                	mov    %edx,%eax
  80082a:	83 ec 0c             	sub    $0xc,%esp
  80082d:	6a 00                	push   $0x0
  80082f:	6a 65                	push   $0x65
  800831:	6a 00                	push   $0x0
  800833:	68 02 02 00 00       	push   $0x202
  800838:	50                   	push   %eax
  800839:	e8 c1 19 00 00       	call   8021ff <tst>
  80083e:	83 c4 20             	add    $0x20,%esp
		byteArr = (char *) ptr_allocations[6];
  800841:	8b 45 98             	mov    -0x68(%ebp),%eax
  800844:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800847:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80084a:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[0]) ,0, 'e', 0);
  80084d:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800850:	e8 51 19 00 00       	call   8021a6 <sys_rcr2>
  800855:	83 ec 0c             	sub    $0xc,%esp
  800858:	6a 00                	push   $0x0
  80085a:	6a 65                	push   $0x65
  80085c:	6a 00                	push   $0x0
  80085e:	53                   	push   %ebx
  80085f:	50                   	push   %eax
  800860:	e8 9a 19 00 00       	call   8021ff <tst>
  800865:	83 c4 20             	add    $0x20,%esp
		byteArr[lastIndices[6]] = 10;
  800868:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  80086e:	89 c2                	mov    %eax,%edx
  800870:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800873:	01 d0                	add    %edx,%eax
  800875:	c6 00 0a             	movb   $0xa,(%eax)
		tst(sys_rcr2(), (uint32)&(byteArr[lastIndices[6]]) ,0, 'e', 0);
  800878:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  80087e:	89 c2                	mov    %eax,%edx
  800880:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800883:	01 d0                	add    %edx,%eax
  800885:	89 c3                	mov    %eax,%ebx
  800887:	e8 1a 19 00 00       	call   8021a6 <sys_rcr2>
  80088c:	83 ec 0c             	sub    $0xc,%esp
  80088f:	6a 00                	push   $0x0
  800891:	6a 65                	push   $0x65
  800893:	6a 00                	push   $0x0
  800895:	53                   	push   %ebx
  800896:	50                   	push   %eax
  800897:	e8 63 19 00 00       	call   8021ff <tst>
  80089c:	83 c4 20             	add    $0x20,%esp

		tst(start_freeFrames, sys_calculate_free_frames() ,0, 'e', 0);
  80089f:	e8 04 16 00 00       	call   801ea8 <sys_calculate_free_frames>
  8008a4:	89 c2                	mov    %eax,%edx
  8008a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008a9:	83 ec 0c             	sub    $0xc,%esp
  8008ac:	6a 00                	push   $0x0
  8008ae:	6a 65                	push   $0x65
  8008b0:	6a 00                	push   $0x0
  8008b2:	52                   	push   %edx
  8008b3:	50                   	push   %eax
  8008b4:	e8 46 19 00 00       	call   8021ff <tst>
  8008b9:	83 c4 20             	add    $0x20,%esp
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  8008bc:	83 ec 0c             	sub    $0xc,%esp
  8008bf:	6a 00                	push   $0x0
  8008c1:	e8 f9 18 00 00       	call   8021bf <sys_bypassPageFault>
  8008c6:	83 c4 10             	add    $0x10,%esp

	chktst(36);
  8008c9:	83 ec 0c             	sub    $0xc,%esp
  8008cc:	6a 24                	push   $0x24
  8008ce:	e8 57 19 00 00       	call   80222a <chktst>
  8008d3:	83 c4 10             	add    $0x10,%esp

	return;
  8008d6:	90                   	nop
}
  8008d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008da:	5b                   	pop    %ebx
  8008db:	5e                   	pop    %esi
  8008dc:	5f                   	pop    %edi
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    

008008df <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8008e5:	e8 f3 14 00 00       	call   801ddd <sys_getenvindex>
  8008ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8008ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008f0:	89 d0                	mov    %edx,%eax
  8008f2:	c1 e0 03             	shl    $0x3,%eax
  8008f5:	01 d0                	add    %edx,%eax
  8008f7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8008fe:	01 c8                	add    %ecx,%eax
  800900:	01 c0                	add    %eax,%eax
  800902:	01 d0                	add    %edx,%eax
  800904:	01 c0                	add    %eax,%eax
  800906:	01 d0                	add    %edx,%eax
  800908:	89 c2                	mov    %eax,%edx
  80090a:	c1 e2 05             	shl    $0x5,%edx
  80090d:	29 c2                	sub    %eax,%edx
  80090f:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800916:	89 c2                	mov    %eax,%edx
  800918:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80091e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800923:	a1 20 30 80 00       	mov    0x803020,%eax
  800928:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80092e:	84 c0                	test   %al,%al
  800930:	74 0f                	je     800941 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800932:	a1 20 30 80 00       	mov    0x803020,%eax
  800937:	05 40 3c 01 00       	add    $0x13c40,%eax
  80093c:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800941:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800945:	7e 0a                	jle    800951 <libmain+0x72>
		binaryname = argv[0];
  800947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 0c             	pushl  0xc(%ebp)
  800957:	ff 75 08             	pushl  0x8(%ebp)
  80095a:	e8 d9 f6 ff ff       	call   800038 <_main>
  80095f:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800962:	e8 11 16 00 00       	call   801f78 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800967:	83 ec 0c             	sub    $0xc,%esp
  80096a:	68 f8 27 80 00       	push   $0x8027f8
  80096f:	e8 84 01 00 00       	call   800af8 <cprintf>
  800974:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800977:	a1 20 30 80 00       	mov    0x803020,%eax
  80097c:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800982:	a1 20 30 80 00       	mov    0x803020,%eax
  800987:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80098d:	83 ec 04             	sub    $0x4,%esp
  800990:	52                   	push   %edx
  800991:	50                   	push   %eax
  800992:	68 20 28 80 00       	push   $0x802820
  800997:	e8 5c 01 00 00       	call   800af8 <cprintf>
  80099c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80099f:	a1 20 30 80 00       	mov    0x803020,%eax
  8009a4:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8009aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8009af:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8009b5:	83 ec 04             	sub    $0x4,%esp
  8009b8:	52                   	push   %edx
  8009b9:	50                   	push   %eax
  8009ba:	68 48 28 80 00       	push   $0x802848
  8009bf:	e8 34 01 00 00       	call   800af8 <cprintf>
  8009c4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8009cc:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8009d2:	83 ec 08             	sub    $0x8,%esp
  8009d5:	50                   	push   %eax
  8009d6:	68 89 28 80 00       	push   $0x802889
  8009db:	e8 18 01 00 00       	call   800af8 <cprintf>
  8009e0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8009e3:	83 ec 0c             	sub    $0xc,%esp
  8009e6:	68 f8 27 80 00       	push   $0x8027f8
  8009eb:	e8 08 01 00 00       	call   800af8 <cprintf>
  8009f0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8009f3:	e8 9a 15 00 00       	call   801f92 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8009f8:	e8 19 00 00 00       	call   800a16 <exit>
}
  8009fd:	90                   	nop
  8009fe:	c9                   	leave  
  8009ff:	c3                   	ret    

00800a00 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800a06:	83 ec 0c             	sub    $0xc,%esp
  800a09:	6a 00                	push   $0x0
  800a0b:	e8 99 13 00 00       	call   801da9 <sys_env_destroy>
  800a10:	83 c4 10             	add    $0x10,%esp
}
  800a13:	90                   	nop
  800a14:	c9                   	leave  
  800a15:	c3                   	ret    

00800a16 <exit>:

void
exit(void)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800a1c:	e8 ee 13 00 00       	call   801e0f <sys_env_exit>
}
  800a21:	90                   	nop
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2d:	8b 00                	mov    (%eax),%eax
  800a2f:	8d 48 01             	lea    0x1(%eax),%ecx
  800a32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a35:	89 0a                	mov    %ecx,(%edx)
  800a37:	8b 55 08             	mov    0x8(%ebp),%edx
  800a3a:	88 d1                	mov    %dl,%cl
  800a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a46:	8b 00                	mov    (%eax),%eax
  800a48:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a4d:	75 2c                	jne    800a7b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a4f:	a0 24 30 80 00       	mov    0x803024,%al
  800a54:	0f b6 c0             	movzbl %al,%eax
  800a57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5a:	8b 12                	mov    (%edx),%edx
  800a5c:	89 d1                	mov    %edx,%ecx
  800a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a61:	83 c2 08             	add    $0x8,%edx
  800a64:	83 ec 04             	sub    $0x4,%esp
  800a67:	50                   	push   %eax
  800a68:	51                   	push   %ecx
  800a69:	52                   	push   %edx
  800a6a:	e8 f8 12 00 00       	call   801d67 <sys_cputs>
  800a6f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7e:	8b 40 04             	mov    0x4(%eax),%eax
  800a81:	8d 50 01             	lea    0x1(%eax),%edx
  800a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a87:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a8a:	90                   	nop
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a96:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a9d:	00 00 00 
	b.cnt = 0;
  800aa0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800aa7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800aaa:	ff 75 0c             	pushl  0xc(%ebp)
  800aad:	ff 75 08             	pushl  0x8(%ebp)
  800ab0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ab6:	50                   	push   %eax
  800ab7:	68 24 0a 80 00       	push   $0x800a24
  800abc:	e8 11 02 00 00       	call   800cd2 <vprintfmt>
  800ac1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ac4:	a0 24 30 80 00       	mov    0x803024,%al
  800ac9:	0f b6 c0             	movzbl %al,%eax
  800acc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	50                   	push   %eax
  800ad6:	52                   	push   %edx
  800ad7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800add:	83 c0 08             	add    $0x8,%eax
  800ae0:	50                   	push   %eax
  800ae1:	e8 81 12 00 00       	call   801d67 <sys_cputs>
  800ae6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ae9:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800af0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800af6:	c9                   	leave  
  800af7:	c3                   	ret    

00800af8 <cprintf>:

int cprintf(const char *fmt, ...) {
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800afe:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800b05:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	ff 75 f4             	pushl  -0xc(%ebp)
  800b14:	50                   	push   %eax
  800b15:	e8 73 ff ff ff       	call   800a8d <vcprintf>
  800b1a:	83 c4 10             	add    $0x10,%esp
  800b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b23:	c9                   	leave  
  800b24:	c3                   	ret    

00800b25 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b2b:	e8 48 14 00 00       	call   801f78 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b30:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	83 ec 08             	sub    $0x8,%esp
  800b3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3f:	50                   	push   %eax
  800b40:	e8 48 ff ff ff       	call   800a8d <vcprintf>
  800b45:	83 c4 10             	add    $0x10,%esp
  800b48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800b4b:	e8 42 14 00 00       	call   801f92 <sys_enable_interrupt>
	return cnt;
  800b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	53                   	push   %ebx
  800b59:	83 ec 14             	sub    $0x14,%esp
  800b5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b62:	8b 45 14             	mov    0x14(%ebp),%eax
  800b65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b68:	8b 45 18             	mov    0x18(%ebp),%eax
  800b6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b70:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b73:	77 55                	ja     800bca <printnum+0x75>
  800b75:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b78:	72 05                	jb     800b7f <printnum+0x2a>
  800b7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b7d:	77 4b                	ja     800bca <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b7f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b82:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b85:	8b 45 18             	mov    0x18(%ebp),%eax
  800b88:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8d:	52                   	push   %edx
  800b8e:	50                   	push   %eax
  800b8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b92:	ff 75 f0             	pushl  -0x10(%ebp)
  800b95:	e8 ce 19 00 00       	call   802568 <__udivdi3>
  800b9a:	83 c4 10             	add    $0x10,%esp
  800b9d:	83 ec 04             	sub    $0x4,%esp
  800ba0:	ff 75 20             	pushl  0x20(%ebp)
  800ba3:	53                   	push   %ebx
  800ba4:	ff 75 18             	pushl  0x18(%ebp)
  800ba7:	52                   	push   %edx
  800ba8:	50                   	push   %eax
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	ff 75 08             	pushl  0x8(%ebp)
  800baf:	e8 a1 ff ff ff       	call   800b55 <printnum>
  800bb4:	83 c4 20             	add    $0x20,%esp
  800bb7:	eb 1a                	jmp    800bd3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bb9:	83 ec 08             	sub    $0x8,%esp
  800bbc:	ff 75 0c             	pushl  0xc(%ebp)
  800bbf:	ff 75 20             	pushl  0x20(%ebp)
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	ff d0                	call   *%eax
  800bc7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bca:	ff 4d 1c             	decl   0x1c(%ebp)
  800bcd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800bd1:	7f e6                	jg     800bb9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bd3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be1:	53                   	push   %ebx
  800be2:	51                   	push   %ecx
  800be3:	52                   	push   %edx
  800be4:	50                   	push   %eax
  800be5:	e8 8e 1a 00 00       	call   802678 <__umoddi3>
  800bea:	83 c4 10             	add    $0x10,%esp
  800bed:	05 b4 2a 80 00       	add    $0x802ab4,%eax
  800bf2:	8a 00                	mov    (%eax),%al
  800bf4:	0f be c0             	movsbl %al,%eax
  800bf7:	83 ec 08             	sub    $0x8,%esp
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	50                   	push   %eax
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
}
  800c06:	90                   	nop
  800c07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c0a:	c9                   	leave  
  800c0b:	c3                   	ret    

00800c0c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c0f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c13:	7e 1c                	jle    800c31 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c15:	8b 45 08             	mov    0x8(%ebp),%eax
  800c18:	8b 00                	mov    (%eax),%eax
  800c1a:	8d 50 08             	lea    0x8(%eax),%edx
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	89 10                	mov    %edx,(%eax)
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8b 00                	mov    (%eax),%eax
  800c27:	83 e8 08             	sub    $0x8,%eax
  800c2a:	8b 50 04             	mov    0x4(%eax),%edx
  800c2d:	8b 00                	mov    (%eax),%eax
  800c2f:	eb 40                	jmp    800c71 <getuint+0x65>
	else if (lflag)
  800c31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c35:	74 1e                	je     800c55 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	8b 00                	mov    (%eax),%eax
  800c3c:	8d 50 04             	lea    0x4(%eax),%edx
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	89 10                	mov    %edx,(%eax)
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	8b 00                	mov    (%eax),%eax
  800c49:	83 e8 04             	sub    $0x4,%eax
  800c4c:	8b 00                	mov    (%eax),%eax
  800c4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c53:	eb 1c                	jmp    800c71 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	8b 00                	mov    (%eax),%eax
  800c5a:	8d 50 04             	lea    0x4(%eax),%edx
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	89 10                	mov    %edx,(%eax)
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	8b 00                	mov    (%eax),%eax
  800c67:	83 e8 04             	sub    $0x4,%eax
  800c6a:	8b 00                	mov    (%eax),%eax
  800c6c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c76:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c7a:	7e 1c                	jle    800c98 <getint+0x25>
		return va_arg(*ap, long long);
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8b 00                	mov    (%eax),%eax
  800c81:	8d 50 08             	lea    0x8(%eax),%edx
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	89 10                	mov    %edx,(%eax)
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8b 00                	mov    (%eax),%eax
  800c8e:	83 e8 08             	sub    $0x8,%eax
  800c91:	8b 50 04             	mov    0x4(%eax),%edx
  800c94:	8b 00                	mov    (%eax),%eax
  800c96:	eb 38                	jmp    800cd0 <getint+0x5d>
	else if (lflag)
  800c98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9c:	74 1a                	je     800cb8 <getint+0x45>
		return va_arg(*ap, long);
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	8b 00                	mov    (%eax),%eax
  800ca3:	8d 50 04             	lea    0x4(%eax),%edx
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	89 10                	mov    %edx,(%eax)
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	8b 00                	mov    (%eax),%eax
  800cb0:	83 e8 04             	sub    $0x4,%eax
  800cb3:	8b 00                	mov    (%eax),%eax
  800cb5:	99                   	cltd   
  800cb6:	eb 18                	jmp    800cd0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8b 00                	mov    (%eax),%eax
  800cbd:	8d 50 04             	lea    0x4(%eax),%edx
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 10                	mov    %edx,(%eax)
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8b 00                	mov    (%eax),%eax
  800cca:	83 e8 04             	sub    $0x4,%eax
  800ccd:	8b 00                	mov    (%eax),%eax
  800ccf:	99                   	cltd   
}
  800cd0:	5d                   	pop    %ebp
  800cd1:	c3                   	ret    

00800cd2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
  800cd7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cda:	eb 17                	jmp    800cf3 <vprintfmt+0x21>
			if (ch == '\0')
  800cdc:	85 db                	test   %ebx,%ebx
  800cde:	0f 84 af 03 00 00    	je     801093 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ce4:	83 ec 08             	sub    $0x8,%esp
  800ce7:	ff 75 0c             	pushl  0xc(%ebp)
  800cea:	53                   	push   %ebx
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	ff d0                	call   *%eax
  800cf0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cf3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf6:	8d 50 01             	lea    0x1(%eax),%edx
  800cf9:	89 55 10             	mov    %edx,0x10(%ebp)
  800cfc:	8a 00                	mov    (%eax),%al
  800cfe:	0f b6 d8             	movzbl %al,%ebx
  800d01:	83 fb 25             	cmp    $0x25,%ebx
  800d04:	75 d6                	jne    800cdc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d06:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d0a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d11:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d18:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d1f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d26:	8b 45 10             	mov    0x10(%ebp),%eax
  800d29:	8d 50 01             	lea    0x1(%eax),%edx
  800d2c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	0f b6 d8             	movzbl %al,%ebx
  800d34:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d37:	83 f8 55             	cmp    $0x55,%eax
  800d3a:	0f 87 2b 03 00 00    	ja     80106b <vprintfmt+0x399>
  800d40:	8b 04 85 d8 2a 80 00 	mov    0x802ad8(,%eax,4),%eax
  800d47:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d49:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d4d:	eb d7                	jmp    800d26 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d4f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d53:	eb d1                	jmp    800d26 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d55:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d5c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d5f:	89 d0                	mov    %edx,%eax
  800d61:	c1 e0 02             	shl    $0x2,%eax
  800d64:	01 d0                	add    %edx,%eax
  800d66:	01 c0                	add    %eax,%eax
  800d68:	01 d8                	add    %ebx,%eax
  800d6a:	83 e8 30             	sub    $0x30,%eax
  800d6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d70:	8b 45 10             	mov    0x10(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d78:	83 fb 2f             	cmp    $0x2f,%ebx
  800d7b:	7e 3e                	jle    800dbb <vprintfmt+0xe9>
  800d7d:	83 fb 39             	cmp    $0x39,%ebx
  800d80:	7f 39                	jg     800dbb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d82:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d85:	eb d5                	jmp    800d5c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d87:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8a:	83 c0 04             	add    $0x4,%eax
  800d8d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d90:	8b 45 14             	mov    0x14(%ebp),%eax
  800d93:	83 e8 04             	sub    $0x4,%eax
  800d96:	8b 00                	mov    (%eax),%eax
  800d98:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d9b:	eb 1f                	jmp    800dbc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d9d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800da1:	79 83                	jns    800d26 <vprintfmt+0x54>
				width = 0;
  800da3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800daa:	e9 77 ff ff ff       	jmp    800d26 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800daf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800db6:	e9 6b ff ff ff       	jmp    800d26 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800dbb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800dbc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc0:	0f 89 60 ff ff ff    	jns    800d26 <vprintfmt+0x54>
				width = precision, precision = -1;
  800dc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800dcc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800dd3:	e9 4e ff ff ff       	jmp    800d26 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dd8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ddb:	e9 46 ff ff ff       	jmp    800d26 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800de0:	8b 45 14             	mov    0x14(%ebp),%eax
  800de3:	83 c0 04             	add    $0x4,%eax
  800de6:	89 45 14             	mov    %eax,0x14(%ebp)
  800de9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dec:	83 e8 04             	sub    $0x4,%eax
  800def:	8b 00                	mov    (%eax),%eax
  800df1:	83 ec 08             	sub    $0x8,%esp
  800df4:	ff 75 0c             	pushl  0xc(%ebp)
  800df7:	50                   	push   %eax
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	ff d0                	call   *%eax
  800dfd:	83 c4 10             	add    $0x10,%esp
			break;
  800e00:	e9 89 02 00 00       	jmp    80108e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e05:	8b 45 14             	mov    0x14(%ebp),%eax
  800e08:	83 c0 04             	add    $0x4,%eax
  800e0b:	89 45 14             	mov    %eax,0x14(%ebp)
  800e0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e11:	83 e8 04             	sub    $0x4,%eax
  800e14:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e16:	85 db                	test   %ebx,%ebx
  800e18:	79 02                	jns    800e1c <vprintfmt+0x14a>
				err = -err;
  800e1a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e1c:	83 fb 64             	cmp    $0x64,%ebx
  800e1f:	7f 0b                	jg     800e2c <vprintfmt+0x15a>
  800e21:	8b 34 9d 20 29 80 00 	mov    0x802920(,%ebx,4),%esi
  800e28:	85 f6                	test   %esi,%esi
  800e2a:	75 19                	jne    800e45 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e2c:	53                   	push   %ebx
  800e2d:	68 c5 2a 80 00       	push   $0x802ac5
  800e32:	ff 75 0c             	pushl  0xc(%ebp)
  800e35:	ff 75 08             	pushl  0x8(%ebp)
  800e38:	e8 5e 02 00 00       	call   80109b <printfmt>
  800e3d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e40:	e9 49 02 00 00       	jmp    80108e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e45:	56                   	push   %esi
  800e46:	68 ce 2a 80 00       	push   $0x802ace
  800e4b:	ff 75 0c             	pushl  0xc(%ebp)
  800e4e:	ff 75 08             	pushl  0x8(%ebp)
  800e51:	e8 45 02 00 00       	call   80109b <printfmt>
  800e56:	83 c4 10             	add    $0x10,%esp
			break;
  800e59:	e9 30 02 00 00       	jmp    80108e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e61:	83 c0 04             	add    $0x4,%eax
  800e64:	89 45 14             	mov    %eax,0x14(%ebp)
  800e67:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6a:	83 e8 04             	sub    $0x4,%eax
  800e6d:	8b 30                	mov    (%eax),%esi
  800e6f:	85 f6                	test   %esi,%esi
  800e71:	75 05                	jne    800e78 <vprintfmt+0x1a6>
				p = "(null)";
  800e73:	be d1 2a 80 00       	mov    $0x802ad1,%esi
			if (width > 0 && padc != '-')
  800e78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7c:	7e 6d                	jle    800eeb <vprintfmt+0x219>
  800e7e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e82:	74 67                	je     800eeb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e87:	83 ec 08             	sub    $0x8,%esp
  800e8a:	50                   	push   %eax
  800e8b:	56                   	push   %esi
  800e8c:	e8 0c 03 00 00       	call   80119d <strnlen>
  800e91:	83 c4 10             	add    $0x10,%esp
  800e94:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e97:	eb 16                	jmp    800eaf <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e99:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e9d:	83 ec 08             	sub    $0x8,%esp
  800ea0:	ff 75 0c             	pushl  0xc(%ebp)
  800ea3:	50                   	push   %eax
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	ff d0                	call   *%eax
  800ea9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800eac:	ff 4d e4             	decl   -0x1c(%ebp)
  800eaf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eb3:	7f e4                	jg     800e99 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eb5:	eb 34                	jmp    800eeb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800eb7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ebb:	74 1c                	je     800ed9 <vprintfmt+0x207>
  800ebd:	83 fb 1f             	cmp    $0x1f,%ebx
  800ec0:	7e 05                	jle    800ec7 <vprintfmt+0x1f5>
  800ec2:	83 fb 7e             	cmp    $0x7e,%ebx
  800ec5:	7e 12                	jle    800ed9 <vprintfmt+0x207>
					putch('?', putdat);
  800ec7:	83 ec 08             	sub    $0x8,%esp
  800eca:	ff 75 0c             	pushl  0xc(%ebp)
  800ecd:	6a 3f                	push   $0x3f
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	ff d0                	call   *%eax
  800ed4:	83 c4 10             	add    $0x10,%esp
  800ed7:	eb 0f                	jmp    800ee8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	ff 75 0c             	pushl  0xc(%ebp)
  800edf:	53                   	push   %ebx
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	ff d0                	call   *%eax
  800ee5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ee8:	ff 4d e4             	decl   -0x1c(%ebp)
  800eeb:	89 f0                	mov    %esi,%eax
  800eed:	8d 70 01             	lea    0x1(%eax),%esi
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	0f be d8             	movsbl %al,%ebx
  800ef5:	85 db                	test   %ebx,%ebx
  800ef7:	74 24                	je     800f1d <vprintfmt+0x24b>
  800ef9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800efd:	78 b8                	js     800eb7 <vprintfmt+0x1e5>
  800eff:	ff 4d e0             	decl   -0x20(%ebp)
  800f02:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f06:	79 af                	jns    800eb7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f08:	eb 13                	jmp    800f1d <vprintfmt+0x24b>
				putch(' ', putdat);
  800f0a:	83 ec 08             	sub    $0x8,%esp
  800f0d:	ff 75 0c             	pushl  0xc(%ebp)
  800f10:	6a 20                	push   $0x20
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	ff d0                	call   *%eax
  800f17:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f1a:	ff 4d e4             	decl   -0x1c(%ebp)
  800f1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f21:	7f e7                	jg     800f0a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f23:	e9 66 01 00 00       	jmp    80108e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f28:	83 ec 08             	sub    $0x8,%esp
  800f2b:	ff 75 e8             	pushl  -0x18(%ebp)
  800f2e:	8d 45 14             	lea    0x14(%ebp),%eax
  800f31:	50                   	push   %eax
  800f32:	e8 3c fd ff ff       	call   800c73 <getint>
  800f37:	83 c4 10             	add    $0x10,%esp
  800f3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f46:	85 d2                	test   %edx,%edx
  800f48:	79 23                	jns    800f6d <vprintfmt+0x29b>
				putch('-', putdat);
  800f4a:	83 ec 08             	sub    $0x8,%esp
  800f4d:	ff 75 0c             	pushl  0xc(%ebp)
  800f50:	6a 2d                	push   $0x2d
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	ff d0                	call   *%eax
  800f57:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f60:	f7 d8                	neg    %eax
  800f62:	83 d2 00             	adc    $0x0,%edx
  800f65:	f7 da                	neg    %edx
  800f67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f6d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f74:	e9 bc 00 00 00       	jmp    801035 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f79:	83 ec 08             	sub    $0x8,%esp
  800f7c:	ff 75 e8             	pushl  -0x18(%ebp)
  800f7f:	8d 45 14             	lea    0x14(%ebp),%eax
  800f82:	50                   	push   %eax
  800f83:	e8 84 fc ff ff       	call   800c0c <getuint>
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f91:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f98:	e9 98 00 00 00       	jmp    801035 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f9d:	83 ec 08             	sub    $0x8,%esp
  800fa0:	ff 75 0c             	pushl  0xc(%ebp)
  800fa3:	6a 58                	push   $0x58
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	ff d0                	call   *%eax
  800faa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fad:	83 ec 08             	sub    $0x8,%esp
  800fb0:	ff 75 0c             	pushl  0xc(%ebp)
  800fb3:	6a 58                	push   $0x58
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	ff d0                	call   *%eax
  800fba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fbd:	83 ec 08             	sub    $0x8,%esp
  800fc0:	ff 75 0c             	pushl  0xc(%ebp)
  800fc3:	6a 58                	push   $0x58
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	ff d0                	call   *%eax
  800fca:	83 c4 10             	add    $0x10,%esp
			break;
  800fcd:	e9 bc 00 00 00       	jmp    80108e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	6a 30                	push   $0x30
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	ff d0                	call   *%eax
  800fdf:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fe2:	83 ec 08             	sub    $0x8,%esp
  800fe5:	ff 75 0c             	pushl  0xc(%ebp)
  800fe8:	6a 78                	push   $0x78
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	ff d0                	call   *%eax
  800fef:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ff2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff5:	83 c0 04             	add    $0x4,%eax
  800ff8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ffb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffe:	83 e8 04             	sub    $0x4,%eax
  801001:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801003:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801006:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80100d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801014:	eb 1f                	jmp    801035 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801016:	83 ec 08             	sub    $0x8,%esp
  801019:	ff 75 e8             	pushl  -0x18(%ebp)
  80101c:	8d 45 14             	lea    0x14(%ebp),%eax
  80101f:	50                   	push   %eax
  801020:	e8 e7 fb ff ff       	call   800c0c <getuint>
  801025:	83 c4 10             	add    $0x10,%esp
  801028:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80102b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80102e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801035:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801039:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80103c:	83 ec 04             	sub    $0x4,%esp
  80103f:	52                   	push   %edx
  801040:	ff 75 e4             	pushl  -0x1c(%ebp)
  801043:	50                   	push   %eax
  801044:	ff 75 f4             	pushl  -0xc(%ebp)
  801047:	ff 75 f0             	pushl  -0x10(%ebp)
  80104a:	ff 75 0c             	pushl  0xc(%ebp)
  80104d:	ff 75 08             	pushl  0x8(%ebp)
  801050:	e8 00 fb ff ff       	call   800b55 <printnum>
  801055:	83 c4 20             	add    $0x20,%esp
			break;
  801058:	eb 34                	jmp    80108e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80105a:	83 ec 08             	sub    $0x8,%esp
  80105d:	ff 75 0c             	pushl  0xc(%ebp)
  801060:	53                   	push   %ebx
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	ff d0                	call   *%eax
  801066:	83 c4 10             	add    $0x10,%esp
			break;
  801069:	eb 23                	jmp    80108e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80106b:	83 ec 08             	sub    $0x8,%esp
  80106e:	ff 75 0c             	pushl  0xc(%ebp)
  801071:	6a 25                	push   $0x25
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	ff d0                	call   *%eax
  801078:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80107b:	ff 4d 10             	decl   0x10(%ebp)
  80107e:	eb 03                	jmp    801083 <vprintfmt+0x3b1>
  801080:	ff 4d 10             	decl   0x10(%ebp)
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	48                   	dec    %eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	3c 25                	cmp    $0x25,%al
  80108b:	75 f3                	jne    801080 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80108d:	90                   	nop
		}
	}
  80108e:	e9 47 fc ff ff       	jmp    800cda <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801093:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801094:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801097:	5b                   	pop    %ebx
  801098:	5e                   	pop    %esi
  801099:	5d                   	pop    %ebp
  80109a:	c3                   	ret    

0080109b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8010a4:	83 c0 04             	add    $0x4,%eax
  8010a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b0:	50                   	push   %eax
  8010b1:	ff 75 0c             	pushl  0xc(%ebp)
  8010b4:	ff 75 08             	pushl  0x8(%ebp)
  8010b7:	e8 16 fc ff ff       	call   800cd2 <vprintfmt>
  8010bc:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010bf:	90                   	nop
  8010c0:	c9                   	leave  
  8010c1:	c3                   	ret    

008010c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010c2:	55                   	push   %ebp
  8010c3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c8:	8b 40 08             	mov    0x8(%eax),%eax
  8010cb:	8d 50 01             	lea    0x1(%eax),%edx
  8010ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d7:	8b 10                	mov    (%eax),%edx
  8010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dc:	8b 40 04             	mov    0x4(%eax),%eax
  8010df:	39 c2                	cmp    %eax,%edx
  8010e1:	73 12                	jae    8010f5 <sprintputch+0x33>
		*b->buf++ = ch;
  8010e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e6:	8b 00                	mov    (%eax),%eax
  8010e8:	8d 48 01             	lea    0x1(%eax),%ecx
  8010eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ee:	89 0a                	mov    %ecx,(%edx)
  8010f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f3:	88 10                	mov    %dl,(%eax)
}
  8010f5:	90                   	nop
  8010f6:	5d                   	pop    %ebp
  8010f7:	c3                   	ret    

008010f8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	01 d0                	add    %edx,%eax
  80110f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801112:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801119:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80111d:	74 06                	je     801125 <vsnprintf+0x2d>
  80111f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801123:	7f 07                	jg     80112c <vsnprintf+0x34>
		return -E_INVAL;
  801125:	b8 03 00 00 00       	mov    $0x3,%eax
  80112a:	eb 20                	jmp    80114c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80112c:	ff 75 14             	pushl  0x14(%ebp)
  80112f:	ff 75 10             	pushl  0x10(%ebp)
  801132:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801135:	50                   	push   %eax
  801136:	68 c2 10 80 00       	push   $0x8010c2
  80113b:	e8 92 fb ff ff       	call   800cd2 <vprintfmt>
  801140:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801143:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801146:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801149:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    

0080114e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801154:	8d 45 10             	lea    0x10(%ebp),%eax
  801157:	83 c0 04             	add    $0x4,%eax
  80115a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80115d:	8b 45 10             	mov    0x10(%ebp),%eax
  801160:	ff 75 f4             	pushl  -0xc(%ebp)
  801163:	50                   	push   %eax
  801164:	ff 75 0c             	pushl  0xc(%ebp)
  801167:	ff 75 08             	pushl  0x8(%ebp)
  80116a:	e8 89 ff ff ff       	call   8010f8 <vsnprintf>
  80116f:	83 c4 10             	add    $0x10,%esp
  801172:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801175:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801178:	c9                   	leave  
  801179:	c3                   	ret    

0080117a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
  80117d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801180:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801187:	eb 06                	jmp    80118f <strlen+0x15>
		n++;
  801189:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80118c:	ff 45 08             	incl   0x8(%ebp)
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	84 c0                	test   %al,%al
  801196:	75 f1                	jne    801189 <strlen+0xf>
		n++;
	return n;
  801198:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80119b:	c9                   	leave  
  80119c:	c3                   	ret    

0080119d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011aa:	eb 09                	jmp    8011b5 <strnlen+0x18>
		n++;
  8011ac:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011af:	ff 45 08             	incl   0x8(%ebp)
  8011b2:	ff 4d 0c             	decl   0xc(%ebp)
  8011b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b9:	74 09                	je     8011c4 <strnlen+0x27>
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	84 c0                	test   %al,%al
  8011c2:	75 e8                	jne    8011ac <strnlen+0xf>
		n++;
	return n;
  8011c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011c7:	c9                   	leave  
  8011c8:	c3                   	ret    

008011c9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8011d5:	90                   	nop
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	8d 50 01             	lea    0x1(%eax),%edx
  8011dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8011df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011e5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011e8:	8a 12                	mov    (%edx),%dl
  8011ea:	88 10                	mov    %dl,(%eax)
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	84 c0                	test   %al,%al
  8011f0:	75 e4                	jne    8011d6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    

008011f7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801203:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80120a:	eb 1f                	jmp    80122b <strncpy+0x34>
		*dst++ = *src;
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8d 50 01             	lea    0x1(%eax),%edx
  801212:	89 55 08             	mov    %edx,0x8(%ebp)
  801215:	8b 55 0c             	mov    0xc(%ebp),%edx
  801218:	8a 12                	mov    (%edx),%dl
  80121a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	84 c0                	test   %al,%al
  801223:	74 03                	je     801228 <strncpy+0x31>
			src++;
  801225:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801228:	ff 45 fc             	incl   -0x4(%ebp)
  80122b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80122e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801231:	72 d9                	jb     80120c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801233:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
  80123b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801244:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801248:	74 30                	je     80127a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80124a:	eb 16                	jmp    801262 <strlcpy+0x2a>
			*dst++ = *src++;
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8d 50 01             	lea    0x1(%eax),%edx
  801252:	89 55 08             	mov    %edx,0x8(%ebp)
  801255:	8b 55 0c             	mov    0xc(%ebp),%edx
  801258:	8d 4a 01             	lea    0x1(%edx),%ecx
  80125b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80125e:	8a 12                	mov    (%edx),%dl
  801260:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801262:	ff 4d 10             	decl   0x10(%ebp)
  801265:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801269:	74 09                	je     801274 <strlcpy+0x3c>
  80126b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	84 c0                	test   %al,%al
  801272:	75 d8                	jne    80124c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80127a:	8b 55 08             	mov    0x8(%ebp),%edx
  80127d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801280:	29 c2                	sub    %eax,%edx
  801282:	89 d0                	mov    %edx,%eax
}
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801289:	eb 06                	jmp    801291 <strcmp+0xb>
		p++, q++;
  80128b:	ff 45 08             	incl   0x8(%ebp)
  80128e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	84 c0                	test   %al,%al
  801298:	74 0e                	je     8012a8 <strcmp+0x22>
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	8a 10                	mov    (%eax),%dl
  80129f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a2:	8a 00                	mov    (%eax),%al
  8012a4:	38 c2                	cmp    %al,%dl
  8012a6:	74 e3                	je     80128b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	8a 00                	mov    (%eax),%al
  8012ad:	0f b6 d0             	movzbl %al,%edx
  8012b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	0f b6 c0             	movzbl %al,%eax
  8012b8:	29 c2                	sub    %eax,%edx
  8012ba:	89 d0                	mov    %edx,%eax
}
  8012bc:	5d                   	pop    %ebp
  8012bd:	c3                   	ret    

008012be <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8012c1:	eb 09                	jmp    8012cc <strncmp+0xe>
		n--, p++, q++;
  8012c3:	ff 4d 10             	decl   0x10(%ebp)
  8012c6:	ff 45 08             	incl   0x8(%ebp)
  8012c9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8012cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d0:	74 17                	je     8012e9 <strncmp+0x2b>
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	8a 00                	mov    (%eax),%al
  8012d7:	84 c0                	test   %al,%al
  8012d9:	74 0e                	je     8012e9 <strncmp+0x2b>
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	8a 10                	mov    (%eax),%dl
  8012e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e3:	8a 00                	mov    (%eax),%al
  8012e5:	38 c2                	cmp    %al,%dl
  8012e7:	74 da                	je     8012c3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ed:	75 07                	jne    8012f6 <strncmp+0x38>
		return 0;
  8012ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f4:	eb 14                	jmp    80130a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	8a 00                	mov    (%eax),%al
  8012fb:	0f b6 d0             	movzbl %al,%edx
  8012fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801301:	8a 00                	mov    (%eax),%al
  801303:	0f b6 c0             	movzbl %al,%eax
  801306:	29 c2                	sub    %eax,%edx
  801308:	89 d0                	mov    %edx,%eax
}
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 04             	sub    $0x4,%esp
  801312:	8b 45 0c             	mov    0xc(%ebp),%eax
  801315:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801318:	eb 12                	jmp    80132c <strchr+0x20>
		if (*s == c)
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801322:	75 05                	jne    801329 <strchr+0x1d>
			return (char *) s;
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	eb 11                	jmp    80133a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801329:	ff 45 08             	incl   0x8(%ebp)
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	84 c0                	test   %al,%al
  801333:	75 e5                	jne    80131a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801335:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	83 ec 04             	sub    $0x4,%esp
  801342:	8b 45 0c             	mov    0xc(%ebp),%eax
  801345:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801348:	eb 0d                	jmp    801357 <strfind+0x1b>
		if (*s == c)
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801352:	74 0e                	je     801362 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801354:	ff 45 08             	incl   0x8(%ebp)
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	84 c0                	test   %al,%al
  80135e:	75 ea                	jne    80134a <strfind+0xe>
  801360:	eb 01                	jmp    801363 <strfind+0x27>
		if (*s == c)
			break;
  801362:	90                   	nop
	return (char *) s;
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801366:	c9                   	leave  
  801367:	c3                   	ret    

00801368 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
  80136b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801374:	8b 45 10             	mov    0x10(%ebp),%eax
  801377:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80137a:	eb 0e                	jmp    80138a <memset+0x22>
		*p++ = c;
  80137c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137f:	8d 50 01             	lea    0x1(%eax),%edx
  801382:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801385:	8b 55 0c             	mov    0xc(%ebp),%edx
  801388:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80138a:	ff 4d f8             	decl   -0x8(%ebp)
  80138d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801391:	79 e9                	jns    80137c <memset+0x14>
		*p++ = c;

	return v;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80139e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8013aa:	eb 16                	jmp    8013c2 <memcpy+0x2a>
		*d++ = *s++;
  8013ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013af:	8d 50 01             	lea    0x1(%eax),%edx
  8013b2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013bb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013be:	8a 12                	mov    (%edx),%dl
  8013c0:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8013c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8013cb:	85 c0                	test   %eax,%eax
  8013cd:	75 dd                	jne    8013ac <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013d2:	c9                   	leave  
  8013d3:	c3                   	ret    

008013d4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8013e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013ec:	73 50                	jae    80143e <memmove+0x6a>
  8013ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f4:	01 d0                	add    %edx,%eax
  8013f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013f9:	76 43                	jbe    80143e <memmove+0x6a>
		s += n;
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801401:	8b 45 10             	mov    0x10(%ebp),%eax
  801404:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801407:	eb 10                	jmp    801419 <memmove+0x45>
			*--d = *--s;
  801409:	ff 4d f8             	decl   -0x8(%ebp)
  80140c:	ff 4d fc             	decl   -0x4(%ebp)
  80140f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801412:	8a 10                	mov    (%eax),%dl
  801414:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801417:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801419:	8b 45 10             	mov    0x10(%ebp),%eax
  80141c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80141f:	89 55 10             	mov    %edx,0x10(%ebp)
  801422:	85 c0                	test   %eax,%eax
  801424:	75 e3                	jne    801409 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801426:	eb 23                	jmp    80144b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801428:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142b:	8d 50 01             	lea    0x1(%eax),%edx
  80142e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801431:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801434:	8d 4a 01             	lea    0x1(%edx),%ecx
  801437:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80143a:	8a 12                	mov    (%edx),%dl
  80143c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80143e:	8b 45 10             	mov    0x10(%ebp),%eax
  801441:	8d 50 ff             	lea    -0x1(%eax),%edx
  801444:	89 55 10             	mov    %edx,0x10(%ebp)
  801447:	85 c0                	test   %eax,%eax
  801449:	75 dd                	jne    801428 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801462:	eb 2a                	jmp    80148e <memcmp+0x3e>
		if (*s1 != *s2)
  801464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801467:	8a 10                	mov    (%eax),%dl
  801469:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	38 c2                	cmp    %al,%dl
  801470:	74 16                	je     801488 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801472:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801475:	8a 00                	mov    (%eax),%al
  801477:	0f b6 d0             	movzbl %al,%edx
  80147a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	0f b6 c0             	movzbl %al,%eax
  801482:	29 c2                	sub    %eax,%edx
  801484:	89 d0                	mov    %edx,%eax
  801486:	eb 18                	jmp    8014a0 <memcmp+0x50>
		s1++, s2++;
  801488:	ff 45 fc             	incl   -0x4(%ebp)
  80148b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80148e:	8b 45 10             	mov    0x10(%ebp),%eax
  801491:	8d 50 ff             	lea    -0x1(%eax),%edx
  801494:	89 55 10             	mov    %edx,0x10(%ebp)
  801497:	85 c0                	test   %eax,%eax
  801499:	75 c9                	jne    801464 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80149b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    

008014a2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8014a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ae:	01 d0                	add    %edx,%eax
  8014b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8014b3:	eb 15                	jmp    8014ca <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	0f b6 d0             	movzbl %al,%edx
  8014bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c0:	0f b6 c0             	movzbl %al,%eax
  8014c3:	39 c2                	cmp    %eax,%edx
  8014c5:	74 0d                	je     8014d4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014c7:	ff 45 08             	incl   0x8(%ebp)
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014d0:	72 e3                	jb     8014b5 <memfind+0x13>
  8014d2:	eb 01                	jmp    8014d5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8014d4:	90                   	nop
	return (void *) s;
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8014e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8014e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014ee:	eb 03                	jmp    8014f3 <strtol+0x19>
		s++;
  8014f0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	3c 20                	cmp    $0x20,%al
  8014fa:	74 f4                	je     8014f0 <strtol+0x16>
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	8a 00                	mov    (%eax),%al
  801501:	3c 09                	cmp    $0x9,%al
  801503:	74 eb                	je     8014f0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	8a 00                	mov    (%eax),%al
  80150a:	3c 2b                	cmp    $0x2b,%al
  80150c:	75 05                	jne    801513 <strtol+0x39>
		s++;
  80150e:	ff 45 08             	incl   0x8(%ebp)
  801511:	eb 13                	jmp    801526 <strtol+0x4c>
	else if (*s == '-')
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	8a 00                	mov    (%eax),%al
  801518:	3c 2d                	cmp    $0x2d,%al
  80151a:	75 0a                	jne    801526 <strtol+0x4c>
		s++, neg = 1;
  80151c:	ff 45 08             	incl   0x8(%ebp)
  80151f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801526:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152a:	74 06                	je     801532 <strtol+0x58>
  80152c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801530:	75 20                	jne    801552 <strtol+0x78>
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	8a 00                	mov    (%eax),%al
  801537:	3c 30                	cmp    $0x30,%al
  801539:	75 17                	jne    801552 <strtol+0x78>
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	40                   	inc    %eax
  80153f:	8a 00                	mov    (%eax),%al
  801541:	3c 78                	cmp    $0x78,%al
  801543:	75 0d                	jne    801552 <strtol+0x78>
		s += 2, base = 16;
  801545:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801549:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801550:	eb 28                	jmp    80157a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801552:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801556:	75 15                	jne    80156d <strtol+0x93>
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	8a 00                	mov    (%eax),%al
  80155d:	3c 30                	cmp    $0x30,%al
  80155f:	75 0c                	jne    80156d <strtol+0x93>
		s++, base = 8;
  801561:	ff 45 08             	incl   0x8(%ebp)
  801564:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80156b:	eb 0d                	jmp    80157a <strtol+0xa0>
	else if (base == 0)
  80156d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801571:	75 07                	jne    80157a <strtol+0xa0>
		base = 10;
  801573:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	8a 00                	mov    (%eax),%al
  80157f:	3c 2f                	cmp    $0x2f,%al
  801581:	7e 19                	jle    80159c <strtol+0xc2>
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	8a 00                	mov    (%eax),%al
  801588:	3c 39                	cmp    $0x39,%al
  80158a:	7f 10                	jg     80159c <strtol+0xc2>
			dig = *s - '0';
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	0f be c0             	movsbl %al,%eax
  801594:	83 e8 30             	sub    $0x30,%eax
  801597:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80159a:	eb 42                	jmp    8015de <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	8a 00                	mov    (%eax),%al
  8015a1:	3c 60                	cmp    $0x60,%al
  8015a3:	7e 19                	jle    8015be <strtol+0xe4>
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	8a 00                	mov    (%eax),%al
  8015aa:	3c 7a                	cmp    $0x7a,%al
  8015ac:	7f 10                	jg     8015be <strtol+0xe4>
			dig = *s - 'a' + 10;
  8015ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b1:	8a 00                	mov    (%eax),%al
  8015b3:	0f be c0             	movsbl %al,%eax
  8015b6:	83 e8 57             	sub    $0x57,%eax
  8015b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015bc:	eb 20                	jmp    8015de <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	8a 00                	mov    (%eax),%al
  8015c3:	3c 40                	cmp    $0x40,%al
  8015c5:	7e 39                	jle    801600 <strtol+0x126>
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	8a 00                	mov    (%eax),%al
  8015cc:	3c 5a                	cmp    $0x5a,%al
  8015ce:	7f 30                	jg     801600 <strtol+0x126>
			dig = *s - 'A' + 10;
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	8a 00                	mov    (%eax),%al
  8015d5:	0f be c0             	movsbl %al,%eax
  8015d8:	83 e8 37             	sub    $0x37,%eax
  8015db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8015de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015e4:	7d 19                	jge    8015ff <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8015e6:	ff 45 08             	incl   0x8(%ebp)
  8015e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ec:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015f0:	89 c2                	mov    %eax,%edx
  8015f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f5:	01 d0                	add    %edx,%eax
  8015f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8015fa:	e9 7b ff ff ff       	jmp    80157a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015ff:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801600:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801604:	74 08                	je     80160e <strtol+0x134>
		*endptr = (char *) s;
  801606:	8b 45 0c             	mov    0xc(%ebp),%eax
  801609:	8b 55 08             	mov    0x8(%ebp),%edx
  80160c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80160e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801612:	74 07                	je     80161b <strtol+0x141>
  801614:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801617:	f7 d8                	neg    %eax
  801619:	eb 03                	jmp    80161e <strtol+0x144>
  80161b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <ltostr>:

void
ltostr(long value, char *str)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801626:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80162d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801634:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801638:	79 13                	jns    80164d <ltostr+0x2d>
	{
		neg = 1;
  80163a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801641:	8b 45 0c             	mov    0xc(%ebp),%eax
  801644:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801647:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80164a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801655:	99                   	cltd   
  801656:	f7 f9                	idiv   %ecx
  801658:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80165b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165e:	8d 50 01             	lea    0x1(%eax),%edx
  801661:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801664:	89 c2                	mov    %eax,%edx
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	01 d0                	add    %edx,%eax
  80166b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80166e:	83 c2 30             	add    $0x30,%edx
  801671:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801673:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801676:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80167b:	f7 e9                	imul   %ecx
  80167d:	c1 fa 02             	sar    $0x2,%edx
  801680:	89 c8                	mov    %ecx,%eax
  801682:	c1 f8 1f             	sar    $0x1f,%eax
  801685:	29 c2                	sub    %eax,%edx
  801687:	89 d0                	mov    %edx,%eax
  801689:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80168c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80168f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801694:	f7 e9                	imul   %ecx
  801696:	c1 fa 02             	sar    $0x2,%edx
  801699:	89 c8                	mov    %ecx,%eax
  80169b:	c1 f8 1f             	sar    $0x1f,%eax
  80169e:	29 c2                	sub    %eax,%edx
  8016a0:	89 d0                	mov    %edx,%eax
  8016a2:	c1 e0 02             	shl    $0x2,%eax
  8016a5:	01 d0                	add    %edx,%eax
  8016a7:	01 c0                	add    %eax,%eax
  8016a9:	29 c1                	sub    %eax,%ecx
  8016ab:	89 ca                	mov    %ecx,%edx
  8016ad:	85 d2                	test   %edx,%edx
  8016af:	75 9c                	jne    80164d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8016b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8016b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016bb:	48                   	dec    %eax
  8016bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8016bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016c3:	74 3d                	je     801702 <ltostr+0xe2>
		start = 1 ;
  8016c5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8016cc:	eb 34                	jmp    801702 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8016ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d4:	01 d0                	add    %edx,%eax
  8016d6:	8a 00                	mov    (%eax),%al
  8016d8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8016db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e1:	01 c2                	add    %eax,%edx
  8016e3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8016e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e9:	01 c8                	add    %ecx,%eax
  8016eb:	8a 00                	mov    (%eax),%al
  8016ed:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8016ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f5:	01 c2                	add    %eax,%edx
  8016f7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8016fa:	88 02                	mov    %al,(%edx)
		start++ ;
  8016fc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8016ff:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801705:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801708:	7c c4                	jl     8016ce <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80170a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80170d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801710:	01 d0                	add    %edx,%eax
  801712:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801715:	90                   	nop
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80171e:	ff 75 08             	pushl  0x8(%ebp)
  801721:	e8 54 fa ff ff       	call   80117a <strlen>
  801726:	83 c4 04             	add    $0x4,%esp
  801729:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80172c:	ff 75 0c             	pushl  0xc(%ebp)
  80172f:	e8 46 fa ff ff       	call   80117a <strlen>
  801734:	83 c4 04             	add    $0x4,%esp
  801737:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80173a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801741:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801748:	eb 17                	jmp    801761 <strcconcat+0x49>
		final[s] = str1[s] ;
  80174a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80174d:	8b 45 10             	mov    0x10(%ebp),%eax
  801750:	01 c2                	add    %eax,%edx
  801752:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	01 c8                	add    %ecx,%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80175e:	ff 45 fc             	incl   -0x4(%ebp)
  801761:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801764:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801767:	7c e1                	jl     80174a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801769:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801770:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801777:	eb 1f                	jmp    801798 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801779:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80177c:	8d 50 01             	lea    0x1(%eax),%edx
  80177f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801782:	89 c2                	mov    %eax,%edx
  801784:	8b 45 10             	mov    0x10(%ebp),%eax
  801787:	01 c2                	add    %eax,%edx
  801789:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80178c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178f:	01 c8                	add    %ecx,%eax
  801791:	8a 00                	mov    (%eax),%al
  801793:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801795:	ff 45 f8             	incl   -0x8(%ebp)
  801798:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80179b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80179e:	7c d9                	jl     801779 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8017a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a6:	01 d0                	add    %edx,%eax
  8017a8:	c6 00 00             	movb   $0x0,(%eax)
}
  8017ab:	90                   	nop
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8017b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8017ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8017bd:	8b 00                	mov    (%eax),%eax
  8017bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c9:	01 d0                	add    %edx,%eax
  8017cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017d1:	eb 0c                	jmp    8017df <strsplit+0x31>
			*string++ = 0;
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	8d 50 01             	lea    0x1(%eax),%edx
  8017d9:	89 55 08             	mov    %edx,0x8(%ebp)
  8017dc:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	8a 00                	mov    (%eax),%al
  8017e4:	84 c0                	test   %al,%al
  8017e6:	74 18                	je     801800 <strsplit+0x52>
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	8a 00                	mov    (%eax),%al
  8017ed:	0f be c0             	movsbl %al,%eax
  8017f0:	50                   	push   %eax
  8017f1:	ff 75 0c             	pushl  0xc(%ebp)
  8017f4:	e8 13 fb ff ff       	call   80130c <strchr>
  8017f9:	83 c4 08             	add    $0x8,%esp
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	75 d3                	jne    8017d3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801800:	8b 45 08             	mov    0x8(%ebp),%eax
  801803:	8a 00                	mov    (%eax),%al
  801805:	84 c0                	test   %al,%al
  801807:	74 5a                	je     801863 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801809:	8b 45 14             	mov    0x14(%ebp),%eax
  80180c:	8b 00                	mov    (%eax),%eax
  80180e:	83 f8 0f             	cmp    $0xf,%eax
  801811:	75 07                	jne    80181a <strsplit+0x6c>
		{
			return 0;
  801813:	b8 00 00 00 00       	mov    $0x0,%eax
  801818:	eb 66                	jmp    801880 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80181a:	8b 45 14             	mov    0x14(%ebp),%eax
  80181d:	8b 00                	mov    (%eax),%eax
  80181f:	8d 48 01             	lea    0x1(%eax),%ecx
  801822:	8b 55 14             	mov    0x14(%ebp),%edx
  801825:	89 0a                	mov    %ecx,(%edx)
  801827:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80182e:	8b 45 10             	mov    0x10(%ebp),%eax
  801831:	01 c2                	add    %eax,%edx
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801838:	eb 03                	jmp    80183d <strsplit+0x8f>
			string++;
  80183a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	84 c0                	test   %al,%al
  801844:	74 8b                	je     8017d1 <strsplit+0x23>
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8a 00                	mov    (%eax),%al
  80184b:	0f be c0             	movsbl %al,%eax
  80184e:	50                   	push   %eax
  80184f:	ff 75 0c             	pushl  0xc(%ebp)
  801852:	e8 b5 fa ff ff       	call   80130c <strchr>
  801857:	83 c4 08             	add    $0x8,%esp
  80185a:	85 c0                	test   %eax,%eax
  80185c:	74 dc                	je     80183a <strsplit+0x8c>
			string++;
	}
  80185e:	e9 6e ff ff ff       	jmp    8017d1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801863:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801864:	8b 45 14             	mov    0x14(%ebp),%eax
  801867:	8b 00                	mov    (%eax),%eax
  801869:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801870:	8b 45 10             	mov    0x10(%ebp),%eax
  801873:	01 d0                	add    %edx,%eax
  801875:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80187b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <malloc>:
struct page pages[(USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE];
uint32 be_space,be_address,first_empty_space,index,ad,
emp_space,find,array_size=0;
int nump,si,ind;
void* malloc(uint32 size)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	//BOOL VARIABLE COUNT FREE SPACES IN MEM
	free_mem_count=0;
  801888:	c7 05 4c 31 80 00 00 	movl   $0x0,0x80314c
  80188f:	00 00 00 
	//BOOL VARIABLE check is there suitable space or not
	find=0;
  801892:	c7 05 48 31 80 00 00 	movl   $0x0,0x803148
  801899:	00 00 00 
	// Initialize user heap memory (1GB = 2^30)->MAX_NUM
	if(intialize_mem==0)
  80189c:	a1 28 30 80 00       	mov    0x803028,%eax
  8018a1:	85 c0                	test   %eax,%eax
  8018a3:	75 65                	jne    80190a <malloc+0x88>
	{
		for(j=USER_HEAP_START;j<USER_HEAP_MAX;j+=PAGE_SIZE)
  8018a5:	c7 05 2c 31 80 00 00 	movl   $0x80000000,0x80312c
  8018ac:	00 00 80 
  8018af:	eb 43                	jmp    8018f4 <malloc+0x72>
		{
			pages[array_size].address=j; // store start address of each 4k(Page_size)
  8018b1:	8b 15 2c 30 80 00    	mov    0x80302c,%edx
  8018b7:	a1 2c 31 80 00       	mov    0x80312c,%eax
  8018bc:	c1 e2 04             	shl    $0x4,%edx
  8018bf:	81 c2 60 31 80 00    	add    $0x803160,%edx
  8018c5:	89 02                	mov    %eax,(%edx)
			pages[array_size].used=0;//not used
  8018c7:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8018cc:	c1 e0 04             	shl    $0x4,%eax
  8018cf:	05 64 31 80 00       	add    $0x803164,%eax
  8018d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			array_size+=1;
  8018da:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8018df:	40                   	inc    %eax
  8018e0:	a3 2c 30 80 00       	mov    %eax,0x80302c
	//BOOL VARIABLE check is there suitable space or not
	find=0;
	// Initialize user heap memory (1GB = 2^30)->MAX_NUM
	if(intialize_mem==0)
	{
		for(j=USER_HEAP_START;j<USER_HEAP_MAX;j+=PAGE_SIZE)
  8018e5:	a1 2c 31 80 00       	mov    0x80312c,%eax
  8018ea:	05 00 10 00 00       	add    $0x1000,%eax
  8018ef:	a3 2c 31 80 00       	mov    %eax,0x80312c
  8018f4:	a1 2c 31 80 00       	mov    0x80312c,%eax
  8018f9:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  8018fe:	76 b1                	jbe    8018b1 <malloc+0x2f>
		{
			pages[array_size].address=j; // store start address of each 4k(Page_size)
			pages[array_size].used=0;//not used
			array_size+=1;
		}
		intialize_mem=1;
  801900:	c7 05 28 30 80 00 01 	movl   $0x1,0x803028
  801907:	00 00 00 
	}
	be_space=MAX_NUM;
  80190a:	c7 05 5c 31 80 00 00 	movl   $0x40000000,0x80315c
  801911:	00 00 40 
	//find upper limit of size and calculate num of pages with given size
	round=ROUNDUP(size/1024,4);
  801914:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	c1 e8 0a             	shr    $0xa,%eax
  801921:	89 c2                	mov    %eax,%edx
  801923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801926:	01 d0                	add    %edx,%eax
  801928:	48                   	dec    %eax
  801929:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80192c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192f:	ba 00 00 00 00       	mov    $0x0,%edx
  801934:	f7 75 f4             	divl   -0xc(%ebp)
  801937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193a:	29 d0                	sub    %edx,%eax
  80193c:	a3 28 31 80 00       	mov    %eax,0x803128
	no_of_pages=round/4;
  801941:	a1 28 31 80 00       	mov    0x803128,%eax
  801946:	c1 e8 02             	shr    $0x2,%eax
  801949:	a3 60 31 a0 00       	mov    %eax,0xa03160
	// find empty spaces in user heap mem
	for(j=0;j<array_size;++j)
  80194e:	c7 05 2c 31 80 00 00 	movl   $0x0,0x80312c
  801955:	00 00 00 
  801958:	e9 96 00 00 00       	jmp    8019f3 <malloc+0x171>
	{
		if(pages[j].used==0) //check empty pages
  80195d:	a1 2c 31 80 00       	mov    0x80312c,%eax
  801962:	c1 e0 04             	shl    $0x4,%eax
  801965:	05 64 31 80 00       	add    $0x803164,%eax
  80196a:	8b 00                	mov    (%eax),%eax
  80196c:	85 c0                	test   %eax,%eax
  80196e:	75 2a                	jne    80199a <malloc+0x118>
		{
			//first empty space only
			if(free_mem_count==0)
  801970:	a1 4c 31 80 00       	mov    0x80314c,%eax
  801975:	85 c0                	test   %eax,%eax
  801977:	75 14                	jne    80198d <malloc+0x10b>
			{
				first_empty_space=pages[j].address;
  801979:	a1 2c 31 80 00       	mov    0x80312c,%eax
  80197e:	c1 e0 04             	shl    $0x4,%eax
  801981:	05 60 31 80 00       	add    $0x803160,%eax
  801986:	8b 00                	mov    (%eax),%eax
  801988:	a3 30 31 80 00       	mov    %eax,0x803130
			}
			free_mem_count++; // increment num of free spaces
  80198d:	a1 4c 31 80 00       	mov    0x80314c,%eax
  801992:	40                   	inc    %eax
  801993:	a3 4c 31 80 00       	mov    %eax,0x80314c
  801998:	eb 4e                	jmp    8019e8 <malloc+0x166>
		}
		else //pages[j].used!=0(==1)used
		{
			// best fit strategy
			emp_space=free_mem_count*PAGE_SIZE;
  80199a:	a1 4c 31 80 00       	mov    0x80314c,%eax
  80199f:	c1 e0 0c             	shl    $0xc,%eax
  8019a2:	a3 34 31 80 00       	mov    %eax,0x803134
			// find min space to fit given size in array
			if(be_space>emp_space&&emp_space>=size)
  8019a7:	8b 15 5c 31 80 00    	mov    0x80315c,%edx
  8019ad:	a1 34 31 80 00       	mov    0x803134,%eax
  8019b2:	39 c2                	cmp    %eax,%edx
  8019b4:	76 28                	jbe    8019de <malloc+0x15c>
  8019b6:	a1 34 31 80 00       	mov    0x803134,%eax
  8019bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019be:	72 1e                	jb     8019de <malloc+0x15c>
			{
				// reset min value to repeat condition to find suitable space (ms7 mosawi2 aw2kbr b shwi2)
				be_space=emp_space;
  8019c0:	a1 34 31 80 00       	mov    0x803134,%eax
  8019c5:	a3 5c 31 80 00       	mov    %eax,0x80315c
				// set start address of empty space
				be_address=first_empty_space;
  8019ca:	a1 30 31 80 00       	mov    0x803130,%eax
  8019cf:	a3 58 31 80 00       	mov    %eax,0x803158
				find=1;
  8019d4:	c7 05 48 31 80 00 01 	movl   $0x1,0x803148
  8019db:	00 00 00 
			}
			free_mem_count=0;
  8019de:	c7 05 4c 31 80 00 00 	movl   $0x0,0x80314c
  8019e5:	00 00 00 
	be_space=MAX_NUM;
	//find upper limit of size and calculate num of pages with given size
	round=ROUNDUP(size/1024,4);
	no_of_pages=round/4;
	// find empty spaces in user heap mem
	for(j=0;j<array_size;++j)
  8019e8:	a1 2c 31 80 00       	mov    0x80312c,%eax
  8019ed:	40                   	inc    %eax
  8019ee:	a3 2c 31 80 00       	mov    %eax,0x80312c
  8019f3:	8b 15 2c 31 80 00    	mov    0x80312c,%edx
  8019f9:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8019fe:	39 c2                	cmp    %eax,%edx
  801a00:	0f 82 57 ff ff ff    	jb     80195d <malloc+0xdb>
			}
			free_mem_count=0;
		}
	}
	// re calc new empty space
	emp_space=free_mem_count*PAGE_SIZE;
  801a06:	a1 4c 31 80 00       	mov    0x80314c,%eax
  801a0b:	c1 e0 0c             	shl    $0xc,%eax
  801a0e:	a3 34 31 80 00       	mov    %eax,0x803134
	// check if this empty space suitable to fit given size or not
	if(be_space>emp_space&&emp_space>=size)
  801a13:	8b 15 5c 31 80 00    	mov    0x80315c,%edx
  801a19:	a1 34 31 80 00       	mov    0x803134,%eax
  801a1e:	39 c2                	cmp    %eax,%edx
  801a20:	76 1e                	jbe    801a40 <malloc+0x1be>
  801a22:	a1 34 31 80 00       	mov    0x803134,%eax
  801a27:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a2a:	72 14                	jb     801a40 <malloc+0x1be>
	{
		find=1;
  801a2c:	c7 05 48 31 80 00 01 	movl   $0x1,0x803148
  801a33:	00 00 00 
		// set final start address of empty space
		be_address=first_empty_space;
  801a36:	a1 30 31 80 00       	mov    0x803130,%eax
  801a3b:	a3 58 31 80 00       	mov    %eax,0x803158
	}
	if(find==0) // no suitable space found
  801a40:	a1 48 31 80 00       	mov    0x803148,%eax
  801a45:	85 c0                	test   %eax,%eax
  801a47:	75 0a                	jne    801a53 <malloc+0x1d1>
	{
		return NULL;
  801a49:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4e:	e9 fa 00 00 00       	jmp    801b4d <malloc+0x2cb>
	}
	for(j=0;j<array_size;++j)
  801a53:	c7 05 2c 31 80 00 00 	movl   $0x0,0x80312c
  801a5a:	00 00 00 
  801a5d:	eb 2f                	jmp    801a8e <malloc+0x20c>
	{
		if (pages[j].address==be_address)
  801a5f:	a1 2c 31 80 00       	mov    0x80312c,%eax
  801a64:	c1 e0 04             	shl    $0x4,%eax
  801a67:	05 60 31 80 00       	add    $0x803160,%eax
  801a6c:	8b 10                	mov    (%eax),%edx
  801a6e:	a1 58 31 80 00       	mov    0x803158,%eax
  801a73:	39 c2                	cmp    %eax,%edx
  801a75:	75 0c                	jne    801a83 <malloc+0x201>
		{
			index=j;
  801a77:	a1 2c 31 80 00       	mov    0x80312c,%eax
  801a7c:	a3 50 31 80 00       	mov    %eax,0x803150
			break;
  801a81:	eb 1a                	jmp    801a9d <malloc+0x21b>
	}
	if(find==0) // no suitable space found
	{
		return NULL;
	}
	for(j=0;j<array_size;++j)
  801a83:	a1 2c 31 80 00       	mov    0x80312c,%eax
  801a88:	40                   	inc    %eax
  801a89:	a3 2c 31 80 00       	mov    %eax,0x80312c
  801a8e:	8b 15 2c 31 80 00    	mov    0x80312c,%edx
  801a94:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801a99:	39 c2                	cmp    %eax,%edx
  801a9b:	72 c2                	jb     801a5f <malloc+0x1dd>
			index=j;
			break;
		}
	}
	// set num of pages to address in array
	pages[index].num_of_pages=no_of_pages;
  801a9d:	8b 15 50 31 80 00    	mov    0x803150,%edx
  801aa3:	a1 60 31 a0 00       	mov    0xa03160,%eax
  801aa8:	c1 e2 04             	shl    $0x4,%edx
  801aab:	81 c2 68 31 80 00    	add    $0x803168,%edx
  801ab1:	89 02                	mov    %eax,(%edx)
	pages[index].siize=size;
  801ab3:	a1 50 31 80 00       	mov    0x803150,%eax
  801ab8:	c1 e0 04             	shl    $0x4,%eax
  801abb:	8d 90 6c 31 80 00    	lea    0x80316c(%eax),%edx
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	89 02                	mov    %eax,(%edx)
	ind=index;
  801ac6:	a1 50 31 80 00       	mov    0x803150,%eax
  801acb:	a3 3c 31 80 00       	mov    %eax,0x80313c

	// loop in n to reset used value to 1 b3add l pages
	for(j=0;j<no_of_pages;++j)
  801ad0:	c7 05 2c 31 80 00 00 	movl   $0x0,0x80312c
  801ad7:	00 00 00 
  801ada:	eb 29                	jmp    801b05 <malloc+0x283>
	{
		pages[index].used=1;
  801adc:	a1 50 31 80 00       	mov    0x803150,%eax
  801ae1:	c1 e0 04             	shl    $0x4,%eax
  801ae4:	05 64 31 80 00       	add    $0x803164,%eax
  801ae9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		++index;
  801aef:	a1 50 31 80 00       	mov    0x803150,%eax
  801af4:	40                   	inc    %eax
  801af5:	a3 50 31 80 00       	mov    %eax,0x803150
	pages[index].num_of_pages=no_of_pages;
	pages[index].siize=size;
	ind=index;

	// loop in n to reset used value to 1 b3add l pages
	for(j=0;j<no_of_pages;++j)
  801afa:	a1 2c 31 80 00       	mov    0x80312c,%eax
  801aff:	40                   	inc    %eax
  801b00:	a3 2c 31 80 00       	mov    %eax,0x80312c
  801b05:	8b 15 2c 31 80 00    	mov    0x80312c,%edx
  801b0b:	a1 60 31 a0 00       	mov    0xa03160,%eax
  801b10:	39 c2                	cmp    %eax,%edx
  801b12:	72 c8                	jb     801adc <malloc+0x25a>
	{
		pages[index].used=1;
		++index;
	}
	// Swap from user heap to kernel
	sys_allocateMem(be_address,size);
  801b14:	a1 58 31 80 00       	mov    0x803158,%eax
  801b19:	83 ec 08             	sub    $0x8,%esp
  801b1c:	ff 75 08             	pushl  0x8(%ebp)
  801b1f:	50                   	push   %eax
  801b20:	e8 ea 03 00 00       	call   801f0f <sys_allocateMem>
  801b25:	83 c4 10             	add    $0x10,%esp
	ad = be_address;
  801b28:	a1 58 31 80 00       	mov    0x803158,%eax
  801b2d:	a3 20 31 80 00       	mov    %eax,0x803120
	si = size/2;
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	d1 e8                	shr    %eax
  801b37:	a3 38 31 80 00       	mov    %eax,0x803138
	nump = no_of_pages/2;
  801b3c:	a1 60 31 a0 00       	mov    0xa03160,%eax
  801b41:	d1 e8                	shr    %eax
  801b43:	a3 40 31 80 00       	mov    %eax,0x803140
	return (void*)be_address;
  801b48:	a1 58 31 80 00       	mov    0x803158,%eax
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	return NULL;
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <free>:

uint32 size, maxmam_size,fif;
void free(void* virtual_address)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	83 ec 28             	sub    $0x28,%esp
int index;
	//found index of virtual address
	for(int i=0;i<array_size;i++)
  801b55:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801b5c:	eb 1d                	jmp    801b7b <free+0x2c>
	{
		if((void *)pages[i].address == virtual_address)
  801b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b61:	c1 e0 04             	shl    $0x4,%eax
  801b64:	05 60 31 80 00       	add    $0x803160,%eax
  801b69:	8b 00                	mov    (%eax),%eax
  801b6b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b6e:	75 08                	jne    801b78 <free+0x29>
		{
			index = i;
  801b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
			break;
  801b76:	eb 0f                	jmp    801b87 <free+0x38>
uint32 size, maxmam_size,fif;
void free(void* virtual_address)
{
int index;
	//found index of virtual address
	for(int i=0;i<array_size;i++)
  801b78:	ff 45 f0             	incl   -0x10(%ebp)
  801b7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b7e:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801b83:	39 c2                	cmp    %eax,%edx
  801b85:	72 d7                	jb     801b5e <free+0xf>
			break;
		}
	}

	//get num of pages
	int num_of_pages = pages[index].num_of_pages;
  801b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8a:	c1 e0 04             	shl    $0x4,%eax
  801b8d:	05 68 31 80 00       	add    $0x803168,%eax
  801b92:	8b 00                	mov    (%eax),%eax
  801b94:	89 45 e8             	mov    %eax,-0x18(%ebp)
	pages[index].num_of_pages=0;
  801b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9a:	c1 e0 04             	shl    $0x4,%eax
  801b9d:	05 68 31 80 00       	add    $0x803168,%eax
  801ba2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	uint32 va = pages[index].address;
  801ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bab:	c1 e0 04             	shl    $0x4,%eax
  801bae:	05 60 31 80 00       	add    $0x803160,%eax
  801bb3:	8b 00                	mov    (%eax),%eax
  801bb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//set used to 0
	for(int i=0;i<num_of_pages;i++)
  801bb8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801bbf:	eb 17                	jmp    801bd8 <free+0x89>
	{
		pages[index].used=0;
  801bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc4:	c1 e0 04             	shl    $0x4,%eax
  801bc7:	05 64 31 80 00       	add    $0x803164,%eax
  801bcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		index++;
  801bd2:	ff 45 f4             	incl   -0xc(%ebp)
	int num_of_pages = pages[index].num_of_pages;
	pages[index].num_of_pages=0;
	uint32 va = pages[index].address;

	//set used to 0
	for(int i=0;i<num_of_pages;i++)
  801bd5:	ff 45 ec             	incl   -0x14(%ebp)
  801bd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bdb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801bde:	7c e1                	jl     801bc1 <free+0x72>
	{
		pages[index].used=0;
		index++;
	}
	// Swap from user heap to kernel
	sys_freeMem(va, num_of_pages*PAGE_SIZE);
  801be0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801be3:	c1 e0 0c             	shl    $0xc,%eax
  801be6:	83 ec 08             	sub    $0x8,%esp
  801be9:	50                   	push   %eax
  801bea:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bed:	e8 01 03 00 00       	call   801ef3 <sys_freeMem>
  801bf2:	83 c4 10             	add    $0x10,%esp
}
  801bf5:	90                   	nop
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	83 ec 18             	sub    $0x18,%esp
  801bfe:	8b 45 10             	mov    0x10(%ebp),%eax
  801c01:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801c04:	83 ec 04             	sub    $0x4,%esp
  801c07:	68 30 2c 80 00       	push   $0x802c30
  801c0c:	68 a0 00 00 00       	push   $0xa0
  801c11:	68 53 2c 80 00       	push   $0x802c53
  801c16:	e8 7e 07 00 00       	call   802399 <_panic>

00801c1b <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	68 30 2c 80 00       	push   $0x802c30
  801c29:	68 a6 00 00 00       	push   $0xa6
  801c2e:	68 53 2c 80 00       	push   $0x802c53
  801c33:	e8 61 07 00 00       	call   802399 <_panic>

00801c38 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c3e:	83 ec 04             	sub    $0x4,%esp
  801c41:	68 30 2c 80 00       	push   $0x802c30
  801c46:	68 ac 00 00 00       	push   $0xac
  801c4b:	68 53 2c 80 00       	push   $0x802c53
  801c50:	e8 44 07 00 00       	call   802399 <_panic>

00801c55 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c5b:	83 ec 04             	sub    $0x4,%esp
  801c5e:	68 30 2c 80 00       	push   $0x802c30
  801c63:	68 b1 00 00 00       	push   $0xb1
  801c68:	68 53 2c 80 00       	push   $0x802c53
  801c6d:	e8 27 07 00 00       	call   802399 <_panic>

00801c72 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
  801c75:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c78:	83 ec 04             	sub    $0x4,%esp
  801c7b:	68 30 2c 80 00       	push   $0x802c30
  801c80:	68 b7 00 00 00       	push   $0xb7
  801c85:	68 53 2c 80 00       	push   $0x802c53
  801c8a:	e8 0a 07 00 00       	call   802399 <_panic>

00801c8f <shrink>:
}
void shrink(uint32 newSize)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c95:	83 ec 04             	sub    $0x4,%esp
  801c98:	68 30 2c 80 00       	push   $0x802c30
  801c9d:	68 bb 00 00 00       	push   $0xbb
  801ca2:	68 53 2c 80 00       	push   $0x802c53
  801ca7:	e8 ed 06 00 00       	call   802399 <_panic>

00801cac <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801cb2:	83 ec 04             	sub    $0x4,%esp
  801cb5:	68 30 2c 80 00       	push   $0x802c30
  801cba:	68 c0 00 00 00       	push   $0xc0
  801cbf:	68 53 2c 80 00       	push   $0x802c53
  801cc4:	e8 d0 06 00 00       	call   802399 <_panic>

00801cc9 <halfLast>:
}

void halfLast(){
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	83 ec 18             	sub    $0x18,%esp
	for(i=array_size;i>pa/2;--i)
	{
		pages[va].used=0;
		va+=PAGE_SIZE;
	}*/
	uint32 halfAdd = ad+si;
  801ccf:	a1 20 31 80 00       	mov    0x803120,%eax
  801cd4:	8b 15 38 31 80 00    	mov    0x803138,%edx
  801cda:	01 d0                	add    %edx,%eax
  801cdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	ind+=nump;
  801cdf:	8b 15 3c 31 80 00    	mov    0x80313c,%edx
  801ce5:	a1 40 31 80 00       	mov    0x803140,%eax
  801cea:	01 d0                	add    %edx,%eax
  801cec:	a3 3c 31 80 00       	mov    %eax,0x80313c
	for(int i=0;i<nump;i++){
  801cf1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801cf8:	eb 21                	jmp    801d1b <halfLast+0x52>
		pages[ind].used=0;
  801cfa:	a1 3c 31 80 00       	mov    0x80313c,%eax
  801cff:	c1 e0 04             	shl    $0x4,%eax
  801d02:	05 64 31 80 00       	add    $0x803164,%eax
  801d07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		ind++;
  801d0d:	a1 3c 31 80 00       	mov    0x80313c,%eax
  801d12:	40                   	inc    %eax
  801d13:	a3 3c 31 80 00       	mov    %eax,0x80313c
		pages[va].used=0;
		va+=PAGE_SIZE;
	}*/
	uint32 halfAdd = ad+si;
	ind+=nump;
	for(int i=0;i<nump;i++){
  801d18:	ff 45 f4             	incl   -0xc(%ebp)
  801d1b:	a1 40 31 80 00       	mov    0x803140,%eax
  801d20:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801d23:	7c d5                	jl     801cfa <halfLast+0x31>
		pages[ind].used=0;
		ind++;
	}
	sys_freeMem(halfAdd,si);
  801d25:	a1 38 31 80 00       	mov    0x803138,%eax
  801d2a:	83 ec 08             	sub    $0x8,%esp
  801d2d:	50                   	push   %eax
  801d2e:	ff 75 f0             	pushl  -0x10(%ebp)
  801d31:	e8 bd 01 00 00       	call   801ef3 <sys_freeMem>
  801d36:	83 c4 10             	add    $0x10,%esp
	//free((void*)ad);
	//malloc(nup);
}
  801d39:	90                   	nop
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	57                   	push   %edi
  801d40:	56                   	push   %esi
  801d41:	53                   	push   %ebx
  801d42:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d4e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d51:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d54:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d57:	cd 30                	int    $0x30
  801d59:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d5f:	83 c4 10             	add    $0x10,%esp
  801d62:	5b                   	pop    %ebx
  801d63:	5e                   	pop    %esi
  801d64:	5f                   	pop    %edi
  801d65:	5d                   	pop    %ebp
  801d66:	c3                   	ret    

00801d67 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	83 ec 04             	sub    $0x4,%esp
  801d6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d70:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d73:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d77:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	52                   	push   %edx
  801d7f:	ff 75 0c             	pushl  0xc(%ebp)
  801d82:	50                   	push   %eax
  801d83:	6a 00                	push   $0x0
  801d85:	e8 b2 ff ff ff       	call   801d3c <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
}
  801d8d:	90                   	nop
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 01                	push   $0x1
  801d9f:	e8 98 ff ff ff       	call   801d3c <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801dac:	8b 45 08             	mov    0x8(%ebp),%eax
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	50                   	push   %eax
  801db8:	6a 05                	push   $0x5
  801dba:	e8 7d ff ff ff       	call   801d3c <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 02                	push   $0x2
  801dd3:	e8 64 ff ff ff       	call   801d3c <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 03                	push   $0x3
  801dec:	e8 4b ff ff ff       	call   801d3c <syscall>
  801df1:	83 c4 18             	add    $0x18,%esp
}
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 04                	push   $0x4
  801e05:	e8 32 ff ff ff       	call   801d3c <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <sys_env_exit>:


void sys_env_exit(void)
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 06                	push   $0x6
  801e1e:	e8 19 ff ff ff       	call   801d3c <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
}
  801e26:	90                   	nop
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	52                   	push   %edx
  801e39:	50                   	push   %eax
  801e3a:	6a 07                	push   $0x7
  801e3c:	e8 fb fe ff ff       	call   801d3c <syscall>
  801e41:	83 c4 18             	add    $0x18,%esp
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	56                   	push   %esi
  801e4a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e4b:	8b 75 18             	mov    0x18(%ebp),%esi
  801e4e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e51:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	56                   	push   %esi
  801e5b:	53                   	push   %ebx
  801e5c:	51                   	push   %ecx
  801e5d:	52                   	push   %edx
  801e5e:	50                   	push   %eax
  801e5f:	6a 08                	push   $0x8
  801e61:	e8 d6 fe ff ff       	call   801d3c <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
}
  801e69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e6c:	5b                   	pop    %ebx
  801e6d:	5e                   	pop    %esi
  801e6e:	5d                   	pop    %ebp
  801e6f:	c3                   	ret    

00801e70 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	52                   	push   %edx
  801e80:	50                   	push   %eax
  801e81:	6a 09                	push   $0x9
  801e83:	e8 b4 fe ff ff       	call   801d3c <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	ff 75 0c             	pushl  0xc(%ebp)
  801e99:	ff 75 08             	pushl  0x8(%ebp)
  801e9c:	6a 0a                	push   $0xa
  801e9e:	e8 99 fe ff ff       	call   801d3c <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 0b                	push   $0xb
  801eb7:	e8 80 fe ff ff       	call   801d3c <syscall>
  801ebc:	83 c4 18             	add    $0x18,%esp
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 0c                	push   $0xc
  801ed0:	e8 67 fe ff ff       	call   801d3c <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 0d                	push   $0xd
  801ee9:	e8 4e fe ff ff       	call   801d3c <syscall>
  801eee:	83 c4 18             	add    $0x18,%esp
}
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	ff 75 0c             	pushl  0xc(%ebp)
  801eff:	ff 75 08             	pushl  0x8(%ebp)
  801f02:	6a 11                	push   $0x11
  801f04:	e8 33 fe ff ff       	call   801d3c <syscall>
  801f09:	83 c4 18             	add    $0x18,%esp
	return;
  801f0c:	90                   	nop
}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	ff 75 0c             	pushl  0xc(%ebp)
  801f1b:	ff 75 08             	pushl  0x8(%ebp)
  801f1e:	6a 12                	push   $0x12
  801f20:	e8 17 fe ff ff       	call   801d3c <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
	return ;
  801f28:	90                   	nop
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 0e                	push   $0xe
  801f3a:	e8 fd fd ff ff       	call   801d3c <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	ff 75 08             	pushl  0x8(%ebp)
  801f52:	6a 0f                	push   $0xf
  801f54:	e8 e3 fd ff ff       	call   801d3c <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 10                	push   $0x10
  801f6d:	e8 ca fd ff ff       	call   801d3c <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
}
  801f75:	90                   	nop
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 14                	push   $0x14
  801f87:	e8 b0 fd ff ff       	call   801d3c <syscall>
  801f8c:	83 c4 18             	add    $0x18,%esp
}
  801f8f:	90                   	nop
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 15                	push   $0x15
  801fa1:	e8 96 fd ff ff       	call   801d3c <syscall>
  801fa6:	83 c4 18             	add    $0x18,%esp
}
  801fa9:	90                   	nop
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <sys_cputc>:


void
sys_cputc(const char c)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 04             	sub    $0x4,%esp
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801fb8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	50                   	push   %eax
  801fc5:	6a 16                	push   $0x16
  801fc7:	e8 70 fd ff ff       	call   801d3c <syscall>
  801fcc:	83 c4 18             	add    $0x18,%esp
}
  801fcf:	90                   	nop
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 17                	push   $0x17
  801fe1:	e8 56 fd ff ff       	call   801d3c <syscall>
  801fe6:	83 c4 18             	add    $0x18,%esp
}
  801fe9:	90                   	nop
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	ff 75 0c             	pushl  0xc(%ebp)
  801ffb:	50                   	push   %eax
  801ffc:	6a 18                	push   $0x18
  801ffe:	e8 39 fd ff ff       	call   801d3c <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80200b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	52                   	push   %edx
  802018:	50                   	push   %eax
  802019:	6a 1b                	push   $0x1b
  80201b:	e8 1c fd ff ff       	call   801d3c <syscall>
  802020:	83 c4 18             	add    $0x18,%esp
}
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802028:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	52                   	push   %edx
  802035:	50                   	push   %eax
  802036:	6a 19                	push   $0x19
  802038:	e8 ff fc ff ff       	call   801d3c <syscall>
  80203d:	83 c4 18             	add    $0x18,%esp
}
  802040:	90                   	nop
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802046:	8b 55 0c             	mov    0xc(%ebp),%edx
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	52                   	push   %edx
  802053:	50                   	push   %eax
  802054:	6a 1a                	push   $0x1a
  802056:	e8 e1 fc ff ff       	call   801d3c <syscall>
  80205b:	83 c4 18             	add    $0x18,%esp
}
  80205e:	90                   	nop
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
  802064:	83 ec 04             	sub    $0x4,%esp
  802067:	8b 45 10             	mov    0x10(%ebp),%eax
  80206a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80206d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802070:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	6a 00                	push   $0x0
  802079:	51                   	push   %ecx
  80207a:	52                   	push   %edx
  80207b:	ff 75 0c             	pushl  0xc(%ebp)
  80207e:	50                   	push   %eax
  80207f:	6a 1c                	push   $0x1c
  802081:	e8 b6 fc ff ff       	call   801d3c <syscall>
  802086:	83 c4 18             	add    $0x18,%esp
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80208e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	52                   	push   %edx
  80209b:	50                   	push   %eax
  80209c:	6a 1d                	push   $0x1d
  80209e:	e8 99 fc ff ff       	call   801d3c <syscall>
  8020a3:	83 c4 18             	add    $0x18,%esp
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	51                   	push   %ecx
  8020b9:	52                   	push   %edx
  8020ba:	50                   	push   %eax
  8020bb:	6a 1e                	push   $0x1e
  8020bd:	e8 7a fc ff ff       	call   801d3c <syscall>
  8020c2:	83 c4 18             	add    $0x18,%esp
}
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	52                   	push   %edx
  8020d7:	50                   	push   %eax
  8020d8:	6a 1f                	push   $0x1f
  8020da:	e8 5d fc ff ff       	call   801d3c <syscall>
  8020df:	83 c4 18             	add    $0x18,%esp
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 20                	push   $0x20
  8020f3:	e8 44 fc ff ff       	call   801d3c <syscall>
  8020f8:	83 c4 18             	add    $0x18,%esp
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	6a 00                	push   $0x0
  802105:	ff 75 14             	pushl  0x14(%ebp)
  802108:	ff 75 10             	pushl  0x10(%ebp)
  80210b:	ff 75 0c             	pushl  0xc(%ebp)
  80210e:	50                   	push   %eax
  80210f:	6a 21                	push   $0x21
  802111:	e8 26 fc ff ff       	call   801d3c <syscall>
  802116:	83 c4 18             	add    $0x18,%esp
}
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80211e:	8b 45 08             	mov    0x8(%ebp),%eax
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	50                   	push   %eax
  80212a:	6a 22                	push   $0x22
  80212c:	e8 0b fc ff ff       	call   801d3c <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
}
  802134:	90                   	nop
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80213a:	8b 45 08             	mov    0x8(%ebp),%eax
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	50                   	push   %eax
  802146:	6a 23                	push   $0x23
  802148:	e8 ef fb ff ff       	call   801d3c <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
}
  802150:	90                   	nop
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
  802156:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802159:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80215c:	8d 50 04             	lea    0x4(%eax),%edx
  80215f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	52                   	push   %edx
  802169:	50                   	push   %eax
  80216a:	6a 24                	push   $0x24
  80216c:	e8 cb fb ff ff       	call   801d3c <syscall>
  802171:	83 c4 18             	add    $0x18,%esp
	return result;
  802174:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802177:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80217a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80217d:	89 01                	mov    %eax,(%ecx)
  80217f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	c9                   	leave  
  802186:	c2 04 00             	ret    $0x4

00802189 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	ff 75 10             	pushl  0x10(%ebp)
  802193:	ff 75 0c             	pushl  0xc(%ebp)
  802196:	ff 75 08             	pushl  0x8(%ebp)
  802199:	6a 13                	push   $0x13
  80219b:	e8 9c fb ff ff       	call   801d3c <syscall>
  8021a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a3:	90                   	nop
}
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 25                	push   $0x25
  8021b5:	e8 82 fb ff ff       	call   801d3c <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	83 ec 04             	sub    $0x4,%esp
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021cb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	50                   	push   %eax
  8021d8:	6a 26                	push   $0x26
  8021da:	e8 5d fb ff ff       	call   801d3c <syscall>
  8021df:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e2:	90                   	nop
}
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <rsttst>:
void rsttst()
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 28                	push   $0x28
  8021f4:	e8 43 fb ff ff       	call   801d3c <syscall>
  8021f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8021fc:	90                   	nop
}
  8021fd:	c9                   	leave  
  8021fe:	c3                   	ret    

008021ff <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021ff:	55                   	push   %ebp
  802200:	89 e5                	mov    %esp,%ebp
  802202:	83 ec 04             	sub    $0x4,%esp
  802205:	8b 45 14             	mov    0x14(%ebp),%eax
  802208:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80220b:	8b 55 18             	mov    0x18(%ebp),%edx
  80220e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802212:	52                   	push   %edx
  802213:	50                   	push   %eax
  802214:	ff 75 10             	pushl  0x10(%ebp)
  802217:	ff 75 0c             	pushl  0xc(%ebp)
  80221a:	ff 75 08             	pushl  0x8(%ebp)
  80221d:	6a 27                	push   $0x27
  80221f:	e8 18 fb ff ff       	call   801d3c <syscall>
  802224:	83 c4 18             	add    $0x18,%esp
	return ;
  802227:	90                   	nop
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <chktst>:
void chktst(uint32 n)
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	ff 75 08             	pushl  0x8(%ebp)
  802238:	6a 29                	push   $0x29
  80223a:	e8 fd fa ff ff       	call   801d3c <syscall>
  80223f:	83 c4 18             	add    $0x18,%esp
	return ;
  802242:	90                   	nop
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <inctst>:

void inctst()
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 2a                	push   $0x2a
  802254:	e8 e3 fa ff ff       	call   801d3c <syscall>
  802259:	83 c4 18             	add    $0x18,%esp
	return ;
  80225c:	90                   	nop
}
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    

0080225f <gettst>:
uint32 gettst()
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 2b                	push   $0x2b
  80226e:	e8 c9 fa ff ff       	call   801d3c <syscall>
  802273:	83 c4 18             	add    $0x18,%esp
}
  802276:	c9                   	leave  
  802277:	c3                   	ret    

00802278 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
  80227b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 2c                	push   $0x2c
  80228a:	e8 ad fa ff ff       	call   801d3c <syscall>
  80228f:	83 c4 18             	add    $0x18,%esp
  802292:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802295:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802299:	75 07                	jne    8022a2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80229b:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a0:	eb 05                	jmp    8022a7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8022a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 2c                	push   $0x2c
  8022bb:	e8 7c fa ff ff       	call   801d3c <syscall>
  8022c0:	83 c4 18             	add    $0x18,%esp
  8022c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022c6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022ca:	75 07                	jne    8022d3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d1:	eb 05                	jmp    8022d8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
  8022dd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 2c                	push   $0x2c
  8022ec:	e8 4b fa ff ff       	call   801d3c <syscall>
  8022f1:	83 c4 18             	add    $0x18,%esp
  8022f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022f7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022fb:	75 07                	jne    802304 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802302:	eb 05                	jmp    802309 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802304:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802309:	c9                   	leave  
  80230a:	c3                   	ret    

0080230b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80230b:	55                   	push   %ebp
  80230c:	89 e5                	mov    %esp,%ebp
  80230e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 2c                	push   $0x2c
  80231d:	e8 1a fa ff ff       	call   801d3c <syscall>
  802322:	83 c4 18             	add    $0x18,%esp
  802325:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802328:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80232c:	75 07                	jne    802335 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80232e:	b8 01 00 00 00       	mov    $0x1,%eax
  802333:	eb 05                	jmp    80233a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802335:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80233a:	c9                   	leave  
  80233b:	c3                   	ret    

0080233c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	ff 75 08             	pushl  0x8(%ebp)
  80234a:	6a 2d                	push   $0x2d
  80234c:	e8 eb f9 ff ff       	call   801d3c <syscall>
  802351:	83 c4 18             	add    $0x18,%esp
	return ;
  802354:	90                   	nop
}
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
  80235a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80235b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80235e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802361:	8b 55 0c             	mov    0xc(%ebp),%edx
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	6a 00                	push   $0x0
  802369:	53                   	push   %ebx
  80236a:	51                   	push   %ecx
  80236b:	52                   	push   %edx
  80236c:	50                   	push   %eax
  80236d:	6a 2e                	push   $0x2e
  80236f:	e8 c8 f9 ff ff       	call   801d3c <syscall>
  802374:	83 c4 18             	add    $0x18,%esp
}
  802377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80237a:	c9                   	leave  
  80237b:	c3                   	ret    

0080237c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80237f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	52                   	push   %edx
  80238c:	50                   	push   %eax
  80238d:	6a 2f                	push   $0x2f
  80238f:	e8 a8 f9 ff ff       	call   801d3c <syscall>
  802394:	83 c4 18             	add    $0x18,%esp
}
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
  80239c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80239f:	8d 45 10             	lea    0x10(%ebp),%eax
  8023a2:	83 c0 04             	add    $0x4,%eax
  8023a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8023a8:	a1 64 31 a0 00       	mov    0xa03164,%eax
  8023ad:	85 c0                	test   %eax,%eax
  8023af:	74 16                	je     8023c7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8023b1:	a1 64 31 a0 00       	mov    0xa03164,%eax
  8023b6:	83 ec 08             	sub    $0x8,%esp
  8023b9:	50                   	push   %eax
  8023ba:	68 60 2c 80 00       	push   $0x802c60
  8023bf:	e8 34 e7 ff ff       	call   800af8 <cprintf>
  8023c4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8023c7:	a1 00 30 80 00       	mov    0x803000,%eax
  8023cc:	ff 75 0c             	pushl  0xc(%ebp)
  8023cf:	ff 75 08             	pushl  0x8(%ebp)
  8023d2:	50                   	push   %eax
  8023d3:	68 65 2c 80 00       	push   $0x802c65
  8023d8:	e8 1b e7 ff ff       	call   800af8 <cprintf>
  8023dd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8023e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8023e3:	83 ec 08             	sub    $0x8,%esp
  8023e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8023e9:	50                   	push   %eax
  8023ea:	e8 9e e6 ff ff       	call   800a8d <vcprintf>
  8023ef:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8023f2:	83 ec 08             	sub    $0x8,%esp
  8023f5:	6a 00                	push   $0x0
  8023f7:	68 81 2c 80 00       	push   $0x802c81
  8023fc:	e8 8c e6 ff ff       	call   800a8d <vcprintf>
  802401:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802404:	e8 0d e6 ff ff       	call   800a16 <exit>

	// should not return here
	while (1) ;
  802409:	eb fe                	jmp    802409 <_panic+0x70>

0080240b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80240b:	55                   	push   %ebp
  80240c:	89 e5                	mov    %esp,%ebp
  80240e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802411:	a1 20 30 80 00       	mov    0x803020,%eax
  802416:	8b 50 74             	mov    0x74(%eax),%edx
  802419:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241c:	39 c2                	cmp    %eax,%edx
  80241e:	74 14                	je     802434 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802420:	83 ec 04             	sub    $0x4,%esp
  802423:	68 84 2c 80 00       	push   $0x802c84
  802428:	6a 26                	push   $0x26
  80242a:	68 d0 2c 80 00       	push   $0x802cd0
  80242f:	e8 65 ff ff ff       	call   802399 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802434:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80243b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802442:	e9 b6 00 00 00       	jmp    8024fd <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  802447:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802451:	8b 45 08             	mov    0x8(%ebp),%eax
  802454:	01 d0                	add    %edx,%eax
  802456:	8b 00                	mov    (%eax),%eax
  802458:	85 c0                	test   %eax,%eax
  80245a:	75 08                	jne    802464 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80245c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80245f:	e9 96 00 00 00       	jmp    8024fa <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  802464:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80246b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802472:	eb 5d                	jmp    8024d1 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802474:	a1 20 30 80 00       	mov    0x803020,%eax
  802479:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80247f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802482:	c1 e2 04             	shl    $0x4,%edx
  802485:	01 d0                	add    %edx,%eax
  802487:	8a 40 04             	mov    0x4(%eax),%al
  80248a:	84 c0                	test   %al,%al
  80248c:	75 40                	jne    8024ce <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80248e:	a1 20 30 80 00       	mov    0x803020,%eax
  802493:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802499:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80249c:	c1 e2 04             	shl    $0x4,%edx
  80249f:	01 d0                	add    %edx,%eax
  8024a1:	8b 00                	mov    (%eax),%eax
  8024a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8024a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8024ae:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8024b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8024ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bd:	01 c8                	add    %ecx,%eax
  8024bf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8024c1:	39 c2                	cmp    %eax,%edx
  8024c3:	75 09                	jne    8024ce <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8024c5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8024cc:	eb 12                	jmp    8024e0 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8024ce:	ff 45 e8             	incl   -0x18(%ebp)
  8024d1:	a1 20 30 80 00       	mov    0x803020,%eax
  8024d6:	8b 50 74             	mov    0x74(%eax),%edx
  8024d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024dc:	39 c2                	cmp    %eax,%edx
  8024de:	77 94                	ja     802474 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8024e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024e4:	75 14                	jne    8024fa <CheckWSWithoutLastIndex+0xef>
			panic(
  8024e6:	83 ec 04             	sub    $0x4,%esp
  8024e9:	68 dc 2c 80 00       	push   $0x802cdc
  8024ee:	6a 3a                	push   $0x3a
  8024f0:	68 d0 2c 80 00       	push   $0x802cd0
  8024f5:	e8 9f fe ff ff       	call   802399 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8024fa:	ff 45 f0             	incl   -0x10(%ebp)
  8024fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802500:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802503:	0f 8c 3e ff ff ff    	jl     802447 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802509:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802510:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802517:	eb 20                	jmp    802539 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802519:	a1 20 30 80 00       	mov    0x803020,%eax
  80251e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802524:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802527:	c1 e2 04             	shl    $0x4,%edx
  80252a:	01 d0                	add    %edx,%eax
  80252c:	8a 40 04             	mov    0x4(%eax),%al
  80252f:	3c 01                	cmp    $0x1,%al
  802531:	75 03                	jne    802536 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  802533:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802536:	ff 45 e0             	incl   -0x20(%ebp)
  802539:	a1 20 30 80 00       	mov    0x803020,%eax
  80253e:	8b 50 74             	mov    0x74(%eax),%edx
  802541:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802544:	39 c2                	cmp    %eax,%edx
  802546:	77 d1                	ja     802519 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80254e:	74 14                	je     802564 <CheckWSWithoutLastIndex+0x159>
		panic(
  802550:	83 ec 04             	sub    $0x4,%esp
  802553:	68 30 2d 80 00       	push   $0x802d30
  802558:	6a 44                	push   $0x44
  80255a:	68 d0 2c 80 00       	push   $0x802cd0
  80255f:	e8 35 fe ff ff       	call   802399 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802564:	90                   	nop
  802565:	c9                   	leave  
  802566:	c3                   	ret    
  802567:	90                   	nop

00802568 <__udivdi3>:
  802568:	55                   	push   %ebp
  802569:	57                   	push   %edi
  80256a:	56                   	push   %esi
  80256b:	53                   	push   %ebx
  80256c:	83 ec 1c             	sub    $0x1c,%esp
  80256f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802573:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802577:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80257b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80257f:	89 ca                	mov    %ecx,%edx
  802581:	89 f8                	mov    %edi,%eax
  802583:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802587:	85 f6                	test   %esi,%esi
  802589:	75 2d                	jne    8025b8 <__udivdi3+0x50>
  80258b:	39 cf                	cmp    %ecx,%edi
  80258d:	77 65                	ja     8025f4 <__udivdi3+0x8c>
  80258f:	89 fd                	mov    %edi,%ebp
  802591:	85 ff                	test   %edi,%edi
  802593:	75 0b                	jne    8025a0 <__udivdi3+0x38>
  802595:	b8 01 00 00 00       	mov    $0x1,%eax
  80259a:	31 d2                	xor    %edx,%edx
  80259c:	f7 f7                	div    %edi
  80259e:	89 c5                	mov    %eax,%ebp
  8025a0:	31 d2                	xor    %edx,%edx
  8025a2:	89 c8                	mov    %ecx,%eax
  8025a4:	f7 f5                	div    %ebp
  8025a6:	89 c1                	mov    %eax,%ecx
  8025a8:	89 d8                	mov    %ebx,%eax
  8025aa:	f7 f5                	div    %ebp
  8025ac:	89 cf                	mov    %ecx,%edi
  8025ae:	89 fa                	mov    %edi,%edx
  8025b0:	83 c4 1c             	add    $0x1c,%esp
  8025b3:	5b                   	pop    %ebx
  8025b4:	5e                   	pop    %esi
  8025b5:	5f                   	pop    %edi
  8025b6:	5d                   	pop    %ebp
  8025b7:	c3                   	ret    
  8025b8:	39 ce                	cmp    %ecx,%esi
  8025ba:	77 28                	ja     8025e4 <__udivdi3+0x7c>
  8025bc:	0f bd fe             	bsr    %esi,%edi
  8025bf:	83 f7 1f             	xor    $0x1f,%edi
  8025c2:	75 40                	jne    802604 <__udivdi3+0x9c>
  8025c4:	39 ce                	cmp    %ecx,%esi
  8025c6:	72 0a                	jb     8025d2 <__udivdi3+0x6a>
  8025c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8025cc:	0f 87 9e 00 00 00    	ja     802670 <__udivdi3+0x108>
  8025d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d7:	89 fa                	mov    %edi,%edx
  8025d9:	83 c4 1c             	add    $0x1c,%esp
  8025dc:	5b                   	pop    %ebx
  8025dd:	5e                   	pop    %esi
  8025de:	5f                   	pop    %edi
  8025df:	5d                   	pop    %ebp
  8025e0:	c3                   	ret    
  8025e1:	8d 76 00             	lea    0x0(%esi),%esi
  8025e4:	31 ff                	xor    %edi,%edi
  8025e6:	31 c0                	xor    %eax,%eax
  8025e8:	89 fa                	mov    %edi,%edx
  8025ea:	83 c4 1c             	add    $0x1c,%esp
  8025ed:	5b                   	pop    %ebx
  8025ee:	5e                   	pop    %esi
  8025ef:	5f                   	pop    %edi
  8025f0:	5d                   	pop    %ebp
  8025f1:	c3                   	ret    
  8025f2:	66 90                	xchg   %ax,%ax
  8025f4:	89 d8                	mov    %ebx,%eax
  8025f6:	f7 f7                	div    %edi
  8025f8:	31 ff                	xor    %edi,%edi
  8025fa:	89 fa                	mov    %edi,%edx
  8025fc:	83 c4 1c             	add    $0x1c,%esp
  8025ff:	5b                   	pop    %ebx
  802600:	5e                   	pop    %esi
  802601:	5f                   	pop    %edi
  802602:	5d                   	pop    %ebp
  802603:	c3                   	ret    
  802604:	bd 20 00 00 00       	mov    $0x20,%ebp
  802609:	89 eb                	mov    %ebp,%ebx
  80260b:	29 fb                	sub    %edi,%ebx
  80260d:	89 f9                	mov    %edi,%ecx
  80260f:	d3 e6                	shl    %cl,%esi
  802611:	89 c5                	mov    %eax,%ebp
  802613:	88 d9                	mov    %bl,%cl
  802615:	d3 ed                	shr    %cl,%ebp
  802617:	89 e9                	mov    %ebp,%ecx
  802619:	09 f1                	or     %esi,%ecx
  80261b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80261f:	89 f9                	mov    %edi,%ecx
  802621:	d3 e0                	shl    %cl,%eax
  802623:	89 c5                	mov    %eax,%ebp
  802625:	89 d6                	mov    %edx,%esi
  802627:	88 d9                	mov    %bl,%cl
  802629:	d3 ee                	shr    %cl,%esi
  80262b:	89 f9                	mov    %edi,%ecx
  80262d:	d3 e2                	shl    %cl,%edx
  80262f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802633:	88 d9                	mov    %bl,%cl
  802635:	d3 e8                	shr    %cl,%eax
  802637:	09 c2                	or     %eax,%edx
  802639:	89 d0                	mov    %edx,%eax
  80263b:	89 f2                	mov    %esi,%edx
  80263d:	f7 74 24 0c          	divl   0xc(%esp)
  802641:	89 d6                	mov    %edx,%esi
  802643:	89 c3                	mov    %eax,%ebx
  802645:	f7 e5                	mul    %ebp
  802647:	39 d6                	cmp    %edx,%esi
  802649:	72 19                	jb     802664 <__udivdi3+0xfc>
  80264b:	74 0b                	je     802658 <__udivdi3+0xf0>
  80264d:	89 d8                	mov    %ebx,%eax
  80264f:	31 ff                	xor    %edi,%edi
  802651:	e9 58 ff ff ff       	jmp    8025ae <__udivdi3+0x46>
  802656:	66 90                	xchg   %ax,%ax
  802658:	8b 54 24 08          	mov    0x8(%esp),%edx
  80265c:	89 f9                	mov    %edi,%ecx
  80265e:	d3 e2                	shl    %cl,%edx
  802660:	39 c2                	cmp    %eax,%edx
  802662:	73 e9                	jae    80264d <__udivdi3+0xe5>
  802664:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802667:	31 ff                	xor    %edi,%edi
  802669:	e9 40 ff ff ff       	jmp    8025ae <__udivdi3+0x46>
  80266e:	66 90                	xchg   %ax,%ax
  802670:	31 c0                	xor    %eax,%eax
  802672:	e9 37 ff ff ff       	jmp    8025ae <__udivdi3+0x46>
  802677:	90                   	nop

00802678 <__umoddi3>:
  802678:	55                   	push   %ebp
  802679:	57                   	push   %edi
  80267a:	56                   	push   %esi
  80267b:	53                   	push   %ebx
  80267c:	83 ec 1c             	sub    $0x1c,%esp
  80267f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802683:	8b 74 24 34          	mov    0x34(%esp),%esi
  802687:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80268b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80268f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802693:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802697:	89 f3                	mov    %esi,%ebx
  802699:	89 fa                	mov    %edi,%edx
  80269b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80269f:	89 34 24             	mov    %esi,(%esp)
  8026a2:	85 c0                	test   %eax,%eax
  8026a4:	75 1a                	jne    8026c0 <__umoddi3+0x48>
  8026a6:	39 f7                	cmp    %esi,%edi
  8026a8:	0f 86 a2 00 00 00    	jbe    802750 <__umoddi3+0xd8>
  8026ae:	89 c8                	mov    %ecx,%eax
  8026b0:	89 f2                	mov    %esi,%edx
  8026b2:	f7 f7                	div    %edi
  8026b4:	89 d0                	mov    %edx,%eax
  8026b6:	31 d2                	xor    %edx,%edx
  8026b8:	83 c4 1c             	add    $0x1c,%esp
  8026bb:	5b                   	pop    %ebx
  8026bc:	5e                   	pop    %esi
  8026bd:	5f                   	pop    %edi
  8026be:	5d                   	pop    %ebp
  8026bf:	c3                   	ret    
  8026c0:	39 f0                	cmp    %esi,%eax
  8026c2:	0f 87 ac 00 00 00    	ja     802774 <__umoddi3+0xfc>
  8026c8:	0f bd e8             	bsr    %eax,%ebp
  8026cb:	83 f5 1f             	xor    $0x1f,%ebp
  8026ce:	0f 84 ac 00 00 00    	je     802780 <__umoddi3+0x108>
  8026d4:	bf 20 00 00 00       	mov    $0x20,%edi
  8026d9:	29 ef                	sub    %ebp,%edi
  8026db:	89 fe                	mov    %edi,%esi
  8026dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026e1:	89 e9                	mov    %ebp,%ecx
  8026e3:	d3 e0                	shl    %cl,%eax
  8026e5:	89 d7                	mov    %edx,%edi
  8026e7:	89 f1                	mov    %esi,%ecx
  8026e9:	d3 ef                	shr    %cl,%edi
  8026eb:	09 c7                	or     %eax,%edi
  8026ed:	89 e9                	mov    %ebp,%ecx
  8026ef:	d3 e2                	shl    %cl,%edx
  8026f1:	89 14 24             	mov    %edx,(%esp)
  8026f4:	89 d8                	mov    %ebx,%eax
  8026f6:	d3 e0                	shl    %cl,%eax
  8026f8:	89 c2                	mov    %eax,%edx
  8026fa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026fe:	d3 e0                	shl    %cl,%eax
  802700:	89 44 24 04          	mov    %eax,0x4(%esp)
  802704:	8b 44 24 08          	mov    0x8(%esp),%eax
  802708:	89 f1                	mov    %esi,%ecx
  80270a:	d3 e8                	shr    %cl,%eax
  80270c:	09 d0                	or     %edx,%eax
  80270e:	d3 eb                	shr    %cl,%ebx
  802710:	89 da                	mov    %ebx,%edx
  802712:	f7 f7                	div    %edi
  802714:	89 d3                	mov    %edx,%ebx
  802716:	f7 24 24             	mull   (%esp)
  802719:	89 c6                	mov    %eax,%esi
  80271b:	89 d1                	mov    %edx,%ecx
  80271d:	39 d3                	cmp    %edx,%ebx
  80271f:	0f 82 87 00 00 00    	jb     8027ac <__umoddi3+0x134>
  802725:	0f 84 91 00 00 00    	je     8027bc <__umoddi3+0x144>
  80272b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80272f:	29 f2                	sub    %esi,%edx
  802731:	19 cb                	sbb    %ecx,%ebx
  802733:	89 d8                	mov    %ebx,%eax
  802735:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802739:	d3 e0                	shl    %cl,%eax
  80273b:	89 e9                	mov    %ebp,%ecx
  80273d:	d3 ea                	shr    %cl,%edx
  80273f:	09 d0                	or     %edx,%eax
  802741:	89 e9                	mov    %ebp,%ecx
  802743:	d3 eb                	shr    %cl,%ebx
  802745:	89 da                	mov    %ebx,%edx
  802747:	83 c4 1c             	add    $0x1c,%esp
  80274a:	5b                   	pop    %ebx
  80274b:	5e                   	pop    %esi
  80274c:	5f                   	pop    %edi
  80274d:	5d                   	pop    %ebp
  80274e:	c3                   	ret    
  80274f:	90                   	nop
  802750:	89 fd                	mov    %edi,%ebp
  802752:	85 ff                	test   %edi,%edi
  802754:	75 0b                	jne    802761 <__umoddi3+0xe9>
  802756:	b8 01 00 00 00       	mov    $0x1,%eax
  80275b:	31 d2                	xor    %edx,%edx
  80275d:	f7 f7                	div    %edi
  80275f:	89 c5                	mov    %eax,%ebp
  802761:	89 f0                	mov    %esi,%eax
  802763:	31 d2                	xor    %edx,%edx
  802765:	f7 f5                	div    %ebp
  802767:	89 c8                	mov    %ecx,%eax
  802769:	f7 f5                	div    %ebp
  80276b:	89 d0                	mov    %edx,%eax
  80276d:	e9 44 ff ff ff       	jmp    8026b6 <__umoddi3+0x3e>
  802772:	66 90                	xchg   %ax,%ax
  802774:	89 c8                	mov    %ecx,%eax
  802776:	89 f2                	mov    %esi,%edx
  802778:	83 c4 1c             	add    $0x1c,%esp
  80277b:	5b                   	pop    %ebx
  80277c:	5e                   	pop    %esi
  80277d:	5f                   	pop    %edi
  80277e:	5d                   	pop    %ebp
  80277f:	c3                   	ret    
  802780:	3b 04 24             	cmp    (%esp),%eax
  802783:	72 06                	jb     80278b <__umoddi3+0x113>
  802785:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802789:	77 0f                	ja     80279a <__umoddi3+0x122>
  80278b:	89 f2                	mov    %esi,%edx
  80278d:	29 f9                	sub    %edi,%ecx
  80278f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802793:	89 14 24             	mov    %edx,(%esp)
  802796:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80279a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80279e:	8b 14 24             	mov    (%esp),%edx
  8027a1:	83 c4 1c             	add    $0x1c,%esp
  8027a4:	5b                   	pop    %ebx
  8027a5:	5e                   	pop    %esi
  8027a6:	5f                   	pop    %edi
  8027a7:	5d                   	pop    %ebp
  8027a8:	c3                   	ret    
  8027a9:	8d 76 00             	lea    0x0(%esi),%esi
  8027ac:	2b 04 24             	sub    (%esp),%eax
  8027af:	19 fa                	sbb    %edi,%edx
  8027b1:	89 d1                	mov    %edx,%ecx
  8027b3:	89 c6                	mov    %eax,%esi
  8027b5:	e9 71 ff ff ff       	jmp    80272b <__umoddi3+0xb3>
  8027ba:	66 90                	xchg   %ax,%ax
  8027bc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8027c0:	72 ea                	jb     8027ac <__umoddi3+0x134>
  8027c2:	89 d9                	mov    %ebx,%ecx
  8027c4:	e9 62 ff ff ff       	jmp    80272b <__umoddi3+0xb3>
