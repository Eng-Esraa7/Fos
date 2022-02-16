
obj/user/tst6:     file format elf32-i386


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
  800031:	e8 4d 06 00 00       	call   800683 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 6c             	sub    $0x6c,%esp
	

	rsttst();
  800041:	e8 43 1f 00 00       	call   801f89 <rsttst>
	
	

	int Mega = 1024*1024;
  800046:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  80004d:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)
	void* ptr_allocations[20] = {0};
  800054:	8d 55 88             	lea    -0x78(%ebp),%edx
  800057:	b9 14 00 00 00       	mov    $0x14,%ecx
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	89 d7                	mov    %edx,%edi
  800063:	f3 ab                	rep stos %eax,%es:(%edi)

	//[1] Attempt to allocate more than heap size
	{
		ptr_allocations[0] = malloc(USER_HEAP_MAX - USER_HEAP_START + 1);
  800065:	83 ec 0c             	sub    $0xc,%esp
  800068:	68 01 00 00 20       	push   $0x20000001
  80006d:	e8 b4 15 00 00       	call   801626 <malloc>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 88             	mov    %eax,-0x78(%ebp)
		tst((uint32) ptr_allocations[0], 0,0, 'b', 0);
  800078:	8b 45 88             	mov    -0x78(%ebp),%eax
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	6a 00                	push   $0x0
  800080:	6a 62                	push   $0x62
  800082:	6a 00                	push   $0x0
  800084:	6a 00                	push   $0x0
  800086:	50                   	push   %eax
  800087:	e8 17 1f 00 00       	call   801fa3 <tst>
  80008c:	83 c4 20             	add    $0x20,%esp

	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  80008f:	e8 b8 1b 00 00       	call   801c4c <sys_calculate_free_frames>
  800094:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800097:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80009a:	01 c0                	add    %eax,%eax
  80009c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80009f:	83 ec 0c             	sub    $0xc,%esp
  8000a2:	50                   	push   %eax
  8000a3:	e8 7e 15 00 00       	call   801626 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	89 45 88             	mov    %eax,-0x78(%ebp)
		tst((uint32) ptr_allocations[0], USER_HEAP_START,USER_HEAP_START + PAGE_SIZE, 'b', 0);
  8000ae:	8b 45 88             	mov    -0x78(%ebp),%eax
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	6a 00                	push   $0x0
  8000b6:	6a 62                	push   $0x62
  8000b8:	68 00 10 00 80       	push   $0x80001000
  8000bd:	68 00 00 00 80       	push   $0x80000000
  8000c2:	50                   	push   %eax
  8000c3:	e8 db 1e 00 00       	call   801fa3 <tst>
  8000c8:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512+1 ,0, 'e', 0);
  8000cb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8000ce:	e8 79 1b 00 00       	call   801c4c <sys_calculate_free_frames>
  8000d3:	29 c3                	sub    %eax,%ebx
  8000d5:	89 d8                	mov    %ebx,%eax
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	6a 00                	push   $0x0
  8000dc:	6a 65                	push   $0x65
  8000de:	6a 00                	push   $0x0
  8000e0:	68 01 02 00 00       	push   $0x201
  8000e5:	50                   	push   %eax
  8000e6:	e8 b8 1e 00 00       	call   801fa3 <tst>
  8000eb:	83 c4 20             	add    $0x20,%esp

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  8000ee:	e8 59 1b 00 00       	call   801c4c <sys_calculate_free_frames>
  8000f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  8000f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f9:	01 c0                	add    %eax,%eax
  8000fb:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	50                   	push   %eax
  800102:	e8 1f 15 00 00       	call   801626 <malloc>
  800107:	83 c4 10             	add    $0x10,%esp
  80010a:	89 45 8c             	mov    %eax,-0x74(%ebp)
		tst((uint32) ptr_allocations[1], USER_HEAP_START+ 2*Mega,USER_HEAP_START + 2*Mega+ PAGE_SIZE, 'b', 0);
  80010d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800110:	01 c0                	add    %eax,%eax
  800112:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800118:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80011b:	01 c0                	add    %eax,%eax
  80011d:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800123:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800126:	83 ec 0c             	sub    $0xc,%esp
  800129:	6a 00                	push   $0x0
  80012b:	6a 62                	push   $0x62
  80012d:	51                   	push   %ecx
  80012e:	52                   	push   %edx
  80012f:	50                   	push   %eax
  800130:	e8 6e 1e 00 00       	call   801fa3 <tst>
  800135:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512 ,0, 'e', 0);
  800138:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80013b:	e8 0c 1b 00 00       	call   801c4c <sys_calculate_free_frames>
  800140:	29 c3                	sub    %eax,%ebx
  800142:	89 d8                	mov    %ebx,%eax
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	6a 00                	push   $0x0
  800149:	6a 65                	push   $0x65
  80014b:	6a 00                	push   $0x0
  80014d:	68 00 02 00 00       	push   $0x200
  800152:	50                   	push   %eax
  800153:	e8 4b 1e 00 00       	call   801fa3 <tst>
  800158:	83 c4 20             	add    $0x20,%esp

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  80015b:	e8 ec 1a 00 00       	call   801c4c <sys_calculate_free_frames>
  800160:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800163:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800166:	01 c0                	add    %eax,%eax
  800168:	83 ec 0c             	sub    $0xc,%esp
  80016b:	50                   	push   %eax
  80016c:	e8 b5 14 00 00       	call   801626 <malloc>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	89 45 90             	mov    %eax,-0x70(%ebp)
		tst((uint32) ptr_allocations[2], USER_HEAP_START+ 4*Mega,USER_HEAP_START + 4*Mega+ PAGE_SIZE, 'b', 0);
  800177:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80017a:	c1 e0 02             	shl    $0x2,%eax
  80017d:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800183:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800186:	c1 e0 02             	shl    $0x2,%eax
  800189:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  80018f:	8b 45 90             	mov    -0x70(%ebp),%eax
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	6a 00                	push   $0x0
  800197:	6a 62                	push   $0x62
  800199:	51                   	push   %ecx
  80019a:	52                   	push   %edx
  80019b:	50                   	push   %eax
  80019c:	e8 02 1e 00 00       	call   801fa3 <tst>
  8001a1:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 1+1 ,0, 'e', 0);
  8001a4:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001a7:	e8 a0 1a 00 00       	call   801c4c <sys_calculate_free_frames>
  8001ac:	29 c3                	sub    %eax,%ebx
  8001ae:	89 d8                	mov    %ebx,%eax
  8001b0:	83 ec 0c             	sub    $0xc,%esp
  8001b3:	6a 00                	push   $0x0
  8001b5:	6a 65                	push   $0x65
  8001b7:	6a 00                	push   $0x0
  8001b9:	6a 02                	push   $0x2
  8001bb:	50                   	push   %eax
  8001bc:	e8 e2 1d 00 00       	call   801fa3 <tst>
  8001c1:	83 c4 20             	add    $0x20,%esp

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001c4:	e8 83 1a 00 00       	call   801c4c <sys_calculate_free_frames>
  8001c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  8001cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001cf:	01 c0                	add    %eax,%eax
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	50                   	push   %eax
  8001d5:	e8 4c 14 00 00       	call   801626 <malloc>
  8001da:	83 c4 10             	add    $0x10,%esp
  8001dd:	89 45 94             	mov    %eax,-0x6c(%ebp)
		tst((uint32) ptr_allocations[3], USER_HEAP_START+ 4*Mega+ 4*kilo,USER_HEAP_START + 4*Mega+ 4*kilo+ PAGE_SIZE, 'b', 0);
  8001e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001e3:	c1 e0 02             	shl    $0x2,%eax
  8001e6:	89 c2                	mov    %eax,%edx
  8001e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001eb:	c1 e0 02             	shl    $0x2,%eax
  8001ee:	01 d0                	add    %edx,%eax
  8001f0:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8001f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001f9:	c1 e0 02             	shl    $0x2,%eax
  8001fc:	89 c2                	mov    %eax,%edx
  8001fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800201:	c1 e0 02             	shl    $0x2,%eax
  800204:	01 d0                	add    %edx,%eax
  800206:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  80020c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	6a 00                	push   $0x0
  800214:	6a 62                	push   $0x62
  800216:	51                   	push   %ecx
  800217:	52                   	push   %edx
  800218:	50                   	push   %eax
  800219:	e8 85 1d 00 00       	call   801fa3 <tst>
  80021e:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 1 ,0, 'e', 0);
  800221:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800224:	e8 23 1a 00 00       	call   801c4c <sys_calculate_free_frames>
  800229:	29 c3                	sub    %eax,%ebx
  80022b:	89 d8                	mov    %ebx,%eax
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	6a 00                	push   $0x0
  800232:	6a 65                	push   $0x65
  800234:	6a 00                	push   $0x0
  800236:	6a 01                	push   $0x1
  800238:	50                   	push   %eax
  800239:	e8 65 1d 00 00       	call   801fa3 <tst>
  80023e:	83 c4 20             	add    $0x20,%esp

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  800241:	e8 06 1a 00 00       	call   801c4c <sys_calculate_free_frames>
  800246:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  800249:	8b 45 90             	mov    -0x70(%ebp),%eax
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	50                   	push   %eax
  800250:	e8 9e 16 00 00       	call   8018f3 <free>
  800255:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 1,0, 'e', 0);
  800258:	e8 ef 19 00 00       	call   801c4c <sys_calculate_free_frames>
  80025d:	89 c2                	mov    %eax,%edx
  80025f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800262:	29 c2                	sub    %eax,%edx
  800264:	89 d0                	mov    %edx,%eax
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	6a 00                	push   $0x0
  80026b:	6a 65                	push   $0x65
  80026d:	6a 00                	push   $0x0
  80026f:	6a 01                	push   $0x1
  800271:	50                   	push   %eax
  800272:	e8 2c 1d 00 00       	call   801fa3 <tst>
  800277:	83 c4 20             	add    $0x20,%esp

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  80027a:	e8 cd 19 00 00       	call   801c4c <sys_calculate_free_frames>
  80027f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800282:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800285:	89 d0                	mov    %edx,%eax
  800287:	01 c0                	add    %eax,%eax
  800289:	01 d0                	add    %edx,%eax
  80028b:	01 c0                	add    %eax,%eax
  80028d:	01 d0                	add    %edx,%eax
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	e8 8e 13 00 00       	call   801626 <malloc>
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	89 45 98             	mov    %eax,-0x68(%ebp)
		tst((uint32) ptr_allocations[4], USER_HEAP_START+ 4*Mega+ 8*kilo,USER_HEAP_START + 4*Mega+ 8*kilo+ PAGE_SIZE, 'b', 0);
  80029e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a1:	c1 e0 02             	shl    $0x2,%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002a9:	c1 e0 03             	shl    $0x3,%eax
  8002ac:	01 d0                	add    %edx,%eax
  8002ae:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8002b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b7:	c1 e0 02             	shl    $0x2,%eax
  8002ba:	89 c2                	mov    %eax,%edx
  8002bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002bf:	c1 e0 03             	shl    $0x3,%eax
  8002c2:	01 d0                	add    %edx,%eax
  8002c4:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8002ca:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002cd:	83 ec 0c             	sub    $0xc,%esp
  8002d0:	6a 00                	push   $0x0
  8002d2:	6a 62                	push   $0x62
  8002d4:	51                   	push   %ecx
  8002d5:	52                   	push   %edx
  8002d6:	50                   	push   %eax
  8002d7:	e8 c7 1c 00 00       	call   801fa3 <tst>
  8002dc:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 2,0, 'e', 0);
  8002df:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002e2:	e8 65 19 00 00       	call   801c4c <sys_calculate_free_frames>
  8002e7:	29 c3                	sub    %eax,%ebx
  8002e9:	89 d8                	mov    %ebx,%eax
  8002eb:	83 ec 0c             	sub    $0xc,%esp
  8002ee:	6a 00                	push   $0x0
  8002f0:	6a 65                	push   $0x65
  8002f2:	6a 00                	push   $0x0
  8002f4:	6a 02                	push   $0x2
  8002f6:	50                   	push   %eax
  8002f7:	e8 a7 1c 00 00       	call   801fa3 <tst>
  8002fc:	83 c4 20             	add    $0x20,%esp

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 48 19 00 00       	call   801c4c <sys_calculate_free_frames>
  800304:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[0]);
  800307:	8b 45 88             	mov    -0x78(%ebp),%eax
  80030a:	83 ec 0c             	sub    $0xc,%esp
  80030d:	50                   	push   %eax
  80030e:	e8 e0 15 00 00       	call   8018f3 <free>
  800313:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 512,0, 'e', 0);
  800316:	e8 31 19 00 00       	call   801c4c <sys_calculate_free_frames>
  80031b:	89 c2                	mov    %eax,%edx
  80031d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800320:	29 c2                	sub    %eax,%edx
  800322:	89 d0                	mov    %edx,%eax
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	6a 00                	push   $0x0
  800329:	6a 65                	push   $0x65
  80032b:	6a 00                	push   $0x0
  80032d:	68 00 02 00 00       	push   $0x200
  800332:	50                   	push   %eax
  800333:	e8 6b 1c 00 00       	call   801fa3 <tst>
  800338:	83 c4 20             	add    $0x20,%esp

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  80033b:	e8 0c 19 00 00       	call   801c4c <sys_calculate_free_frames>
  800340:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800343:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800346:	89 c2                	mov    %eax,%edx
  800348:	01 d2                	add    %edx,%edx
  80034a:	01 d0                	add    %edx,%eax
  80034c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	50                   	push   %eax
  800353:	e8 ce 12 00 00       	call   801626 <malloc>
  800358:	83 c4 10             	add    $0x10,%esp
  80035b:	89 45 9c             	mov    %eax,-0x64(%ebp)
		tst((uint32) ptr_allocations[5], USER_HEAP_START+ 4*Mega+ 16*kilo,USER_HEAP_START + 4*Mega+ 16*kilo+ PAGE_SIZE, 'b', 0);
  80035e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800361:	c1 e0 02             	shl    $0x2,%eax
  800364:	89 c2                	mov    %eax,%edx
  800366:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800369:	c1 e0 04             	shl    $0x4,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800377:	c1 e0 02             	shl    $0x2,%eax
  80037a:	89 c2                	mov    %eax,%edx
  80037c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80037f:	c1 e0 04             	shl    $0x4,%eax
  800382:	01 d0                	add    %edx,%eax
  800384:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  80038a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80038d:	83 ec 0c             	sub    $0xc,%esp
  800390:	6a 00                	push   $0x0
  800392:	6a 62                	push   $0x62
  800394:	51                   	push   %ecx
  800395:	52                   	push   %edx
  800396:	50                   	push   %eax
  800397:	e8 07 1c 00 00       	call   801fa3 <tst>
  80039c:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 3*Mega/4096 ,0, 'e', 0);
  80039f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003a2:	89 c2                	mov    %eax,%edx
  8003a4:	01 d2                	add    %edx,%edx
  8003a6:	01 d0                	add    %edx,%eax
  8003a8:	85 c0                	test   %eax,%eax
  8003aa:	79 05                	jns    8003b1 <_main+0x379>
  8003ac:	05 ff 0f 00 00       	add    $0xfff,%eax
  8003b1:	c1 f8 0c             	sar    $0xc,%eax
  8003b4:	89 c3                	mov    %eax,%ebx
  8003b6:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8003b9:	e8 8e 18 00 00       	call   801c4c <sys_calculate_free_frames>
  8003be:	29 c6                	sub    %eax,%esi
  8003c0:	89 f0                	mov    %esi,%eax
  8003c2:	83 ec 0c             	sub    $0xc,%esp
  8003c5:	6a 00                	push   $0x0
  8003c7:	6a 65                	push   $0x65
  8003c9:	6a 00                	push   $0x0
  8003cb:	53                   	push   %ebx
  8003cc:	50                   	push   %eax
  8003cd:	e8 d1 1b 00 00       	call   801fa3 <tst>
  8003d2:	83 c4 20             	add    $0x20,%esp

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  8003d5:	e8 72 18 00 00       	call   801c4c <sys_calculate_free_frames>
  8003da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  8003dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e0:	89 c2                	mov    %eax,%edx
  8003e2:	01 d2                	add    %edx,%edx
  8003e4:	01 c2                	add    %eax,%edx
  8003e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003e9:	01 d0                	add    %edx,%eax
  8003eb:	01 c0                	add    %eax,%eax
  8003ed:	83 ec 0c             	sub    $0xc,%esp
  8003f0:	50                   	push   %eax
  8003f1:	e8 30 12 00 00       	call   801626 <malloc>
  8003f6:	83 c4 10             	add    $0x10,%esp
  8003f9:	89 45 a0             	mov    %eax,-0x60(%ebp)
		tst((uint32) ptr_allocations[6], USER_HEAP_START+ 7*Mega+ 16*kilo,USER_HEAP_START + 7*Mega+ 16*kilo+ PAGE_SIZE, 'b', 0);
  8003fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003ff:	89 d0                	mov    %edx,%eax
  800401:	01 c0                	add    %eax,%eax
  800403:	01 d0                	add    %edx,%eax
  800405:	01 c0                	add    %eax,%eax
  800407:	01 d0                	add    %edx,%eax
  800409:	89 c2                	mov    %eax,%edx
  80040b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80040e:	c1 e0 04             	shl    $0x4,%eax
  800411:	01 d0                	add    %edx,%eax
  800413:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800419:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	01 c0                	add    %eax,%eax
  800420:	01 d0                	add    %edx,%eax
  800422:	01 c0                	add    %eax,%eax
  800424:	01 d0                	add    %edx,%eax
  800426:	89 c2                	mov    %eax,%edx
  800428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042b:	c1 e0 04             	shl    $0x4,%eax
  80042e:	01 d0                	add    %edx,%eax
  800430:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800436:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800439:	83 ec 0c             	sub    $0xc,%esp
  80043c:	6a 00                	push   $0x0
  80043e:	6a 62                	push   $0x62
  800440:	51                   	push   %ecx
  800441:	52                   	push   %edx
  800442:	50                   	push   %eax
  800443:	e8 5b 1b 00 00       	call   801fa3 <tst>
  800448:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 514+1 ,0, 'e', 0);
  80044b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80044e:	e8 f9 17 00 00       	call   801c4c <sys_calculate_free_frames>
  800453:	29 c3                	sub    %eax,%ebx
  800455:	89 d8                	mov    %ebx,%eax
  800457:	83 ec 0c             	sub    $0xc,%esp
  80045a:	6a 00                	push   $0x0
  80045c:	6a 65                	push   $0x65
  80045e:	6a 00                	push   $0x0
  800460:	68 03 02 00 00       	push   $0x203
  800465:	50                   	push   %eax
  800466:	e8 38 1b 00 00       	call   801fa3 <tst>
  80046b:	83 c4 20             	add    $0x20,%esp

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80046e:	e8 d9 17 00 00       	call   801c4c <sys_calculate_free_frames>
  800473:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[5]);
  800476:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800479:	83 ec 0c             	sub    $0xc,%esp
  80047c:	50                   	push   %eax
  80047d:	e8 71 14 00 00       	call   8018f3 <free>
  800482:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 768,0, 'e', 0);
  800485:	e8 c2 17 00 00       	call   801c4c <sys_calculate_free_frames>
  80048a:	89 c2                	mov    %eax,%edx
  80048c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80048f:	29 c2                	sub    %eax,%edx
  800491:	89 d0                	mov    %edx,%eax
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	6a 00                	push   $0x0
  800498:	6a 65                	push   $0x65
  80049a:	6a 00                	push   $0x0
  80049c:	68 00 03 00 00       	push   $0x300
  8004a1:	50                   	push   %eax
  8004a2:	e8 fc 1a 00 00       	call   801fa3 <tst>
  8004a7:	83 c4 20             	add    $0x20,%esp

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  8004aa:	e8 9d 17 00 00       	call   801c4c <sys_calculate_free_frames>
  8004af:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  8004b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8004b5:	89 d0                	mov    %edx,%eax
  8004b7:	c1 e0 02             	shl    $0x2,%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004bf:	83 ec 0c             	sub    $0xc,%esp
  8004c2:	50                   	push   %eax
  8004c3:	e8 5e 11 00 00       	call   801626 <malloc>
  8004c8:	83 c4 10             	add    $0x10,%esp
  8004cb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		tst((uint32) ptr_allocations[7], USER_HEAP_START+ 9*Mega+ 24*kilo,USER_HEAP_START + 9*Mega+ 24*kilo+ PAGE_SIZE, 'b', 0);
  8004ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8004d1:	89 d0                	mov    %edx,%eax
  8004d3:	c1 e0 03             	shl    $0x3,%eax
  8004d6:	01 d0                	add    %edx,%eax
  8004d8:	89 c1                	mov    %eax,%ecx
  8004da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004dd:	89 d0                	mov    %edx,%eax
  8004df:	01 c0                	add    %eax,%eax
  8004e1:	01 d0                	add    %edx,%eax
  8004e3:	c1 e0 03             	shl    $0x3,%eax
  8004e6:	01 c8                	add    %ecx,%eax
  8004e8:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8004ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8004f1:	89 d0                	mov    %edx,%eax
  8004f3:	c1 e0 03             	shl    $0x3,%eax
  8004f6:	01 d0                	add    %edx,%eax
  8004f8:	89 c3                	mov    %eax,%ebx
  8004fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004fd:	89 d0                	mov    %edx,%eax
  8004ff:	01 c0                	add    %eax,%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	c1 e0 03             	shl    $0x3,%eax
  800506:	01 d8                	add    %ebx,%eax
  800508:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  80050e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800511:	83 ec 0c             	sub    $0xc,%esp
  800514:	6a 00                	push   $0x0
  800516:	6a 62                	push   $0x62
  800518:	51                   	push   %ecx
  800519:	52                   	push   %edx
  80051a:	50                   	push   %eax
  80051b:	e8 83 1a 00 00       	call   801fa3 <tst>
  800520:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 5*Mega/4096 + 1,0, 'e', 0);
  800523:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800526:	89 d0                	mov    %edx,%eax
  800528:	c1 e0 02             	shl    $0x2,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	85 c0                	test   %eax,%eax
  80052f:	79 05                	jns    800536 <_main+0x4fe>
  800531:	05 ff 0f 00 00       	add    $0xfff,%eax
  800536:	c1 f8 0c             	sar    $0xc,%eax
  800539:	40                   	inc    %eax
  80053a:	89 c3                	mov    %eax,%ebx
  80053c:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80053f:	e8 08 17 00 00       	call   801c4c <sys_calculate_free_frames>
  800544:	29 c6                	sub    %eax,%esi
  800546:	89 f0                	mov    %esi,%eax
  800548:	83 ec 0c             	sub    $0xc,%esp
  80054b:	6a 00                	push   $0x0
  80054d:	6a 65                	push   $0x65
  80054f:	6a 00                	push   $0x0
  800551:	53                   	push   %ebx
  800552:	50                   	push   %eax
  800553:	e8 4b 1a 00 00       	call   801fa3 <tst>
  800558:	83 c4 20             	add    $0x20,%esp

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  80055b:	e8 ec 16 00 00       	call   801c4c <sys_calculate_free_frames>
  800560:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  800563:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800566:	83 ec 0c             	sub    $0xc,%esp
  800569:	50                   	push   %eax
  80056a:	e8 84 13 00 00       	call   8018f3 <free>
  80056f:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 514,0, 'e', 0);
  800572:	e8 d5 16 00 00       	call   801c4c <sys_calculate_free_frames>
  800577:	89 c2                	mov    %eax,%edx
  800579:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80057c:	29 c2                	sub    %eax,%edx
  80057e:	89 d0                	mov    %edx,%eax
  800580:	83 ec 0c             	sub    $0xc,%esp
  800583:	6a 00                	push   $0x0
  800585:	6a 65                	push   $0x65
  800587:	6a 00                	push   $0x0
  800589:	68 02 02 00 00       	push   $0x202
  80058e:	50                   	push   %eax
  80058f:	e8 0f 1a 00 00       	call   801fa3 <tst>
  800594:	83 c4 20             	add    $0x20,%esp

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  800597:	e8 b0 16 00 00       	call   801c4c <sys_calculate_free_frames>
  80059c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc(4*Mega-kilo);
  80059f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005a2:	c1 e0 02             	shl    $0x2,%eax
  8005a5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8005a8:	83 ec 0c             	sub    $0xc,%esp
  8005ab:	50                   	push   %eax
  8005ac:	e8 75 10 00 00       	call   801626 <malloc>
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	89 45 a8             	mov    %eax,-0x58(%ebp)
		tst((uint32) ptr_allocations[8], USER_HEAP_START+ 4*Mega+ 16*kilo,USER_HEAP_START + 4*Mega+ 16*kilo+ PAGE_SIZE, 'b', 0);
  8005b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005ba:	c1 e0 02             	shl    $0x2,%eax
  8005bd:	89 c2                	mov    %eax,%edx
  8005bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c2:	c1 e0 04             	shl    $0x4,%eax
  8005c5:	01 d0                	add    %edx,%eax
  8005c7:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8005cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005d0:	c1 e0 02             	shl    $0x2,%eax
  8005d3:	89 c2                	mov    %eax,%edx
  8005d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d8:	c1 e0 04             	shl    $0x4,%eax
  8005db:	01 d0                	add    %edx,%eax
  8005dd:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8005e3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8005e6:	83 ec 0c             	sub    $0xc,%esp
  8005e9:	6a 00                	push   $0x0
  8005eb:	6a 62                	push   $0x62
  8005ed:	51                   	push   %ecx
  8005ee:	52                   	push   %edx
  8005ef:	50                   	push   %eax
  8005f0:	e8 ae 19 00 00       	call   801fa3 <tst>
  8005f5:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 4*Mega/4096,0, 'e', 0);
  8005f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005fb:	c1 e0 02             	shl    $0x2,%eax
  8005fe:	85 c0                	test   %eax,%eax
  800600:	79 05                	jns    800607 <_main+0x5cf>
  800602:	05 ff 0f 00 00       	add    $0xfff,%eax
  800607:	c1 f8 0c             	sar    $0xc,%eax
  80060a:	89 c3                	mov    %eax,%ebx
  80060c:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80060f:	e8 38 16 00 00       	call   801c4c <sys_calculate_free_frames>
  800614:	29 c6                	sub    %eax,%esi
  800616:	89 f0                	mov    %esi,%eax
  800618:	83 ec 0c             	sub    $0xc,%esp
  80061b:	6a 00                	push   $0x0
  80061d:	6a 65                	push   $0x65
  80061f:	6a 00                	push   $0x0
  800621:	53                   	push   %ebx
  800622:	50                   	push   %eax
  800623:	e8 7b 19 00 00       	call   801fa3 <tst>
  800628:	83 c4 20             	add    $0x20,%esp
	}

	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		int freeFrames = sys_calculate_free_frames() ;
  80062b:	e8 1c 16 00 00       	call   801c4c <sys_calculate_free_frames>
  800630:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[9] = malloc((USER_HEAP_MAX - USER_HEAP_START + 14*Mega));
  800633:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800636:	89 d0                	mov    %edx,%eax
  800638:	01 c0                	add    %eax,%eax
  80063a:	01 d0                	add    %edx,%eax
  80063c:	01 c0                	add    %eax,%eax
  80063e:	01 d0                	add    %edx,%eax
  800640:	01 c0                	add    %eax,%eax
  800642:	05 00 00 00 20       	add    $0x20000000,%eax
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	50                   	push   %eax
  80064b:	e8 d6 0f 00 00       	call   801626 <malloc>
  800650:	83 c4 10             	add    $0x10,%esp
  800653:	89 45 ac             	mov    %eax,-0x54(%ebp)
		tst((uint32) ptr_allocations[9], 0,0, 'b', 0);
  800656:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800659:	83 ec 0c             	sub    $0xc,%esp
  80065c:	6a 00                	push   $0x0
  80065e:	6a 62                	push   $0x62
  800660:	6a 00                	push   $0x0
  800662:	6a 00                	push   $0x0
  800664:	50                   	push   %eax
  800665:	e8 39 19 00 00       	call   801fa3 <tst>
  80066a:	83 c4 20             	add    $0x20,%esp

		chktst(24);
  80066d:	83 ec 0c             	sub    $0xc,%esp
  800670:	6a 18                	push   $0x18
  800672:	e8 57 19 00 00       	call   801fce <chktst>
  800677:	83 c4 10             	add    $0x10,%esp

		return;
  80067a:	90                   	nop
	}
}
  80067b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80067e:	5b                   	pop    %ebx
  80067f:	5e                   	pop    %esi
  800680:	5f                   	pop    %edi
  800681:	5d                   	pop    %ebp
  800682:	c3                   	ret    

00800683 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800683:	55                   	push   %ebp
  800684:	89 e5                	mov    %esp,%ebp
  800686:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800689:	e8 f3 14 00 00       	call   801b81 <sys_getenvindex>
  80068e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800691:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800694:	89 d0                	mov    %edx,%eax
  800696:	c1 e0 03             	shl    $0x3,%eax
  800699:	01 d0                	add    %edx,%eax
  80069b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8006a2:	01 c8                	add    %ecx,%eax
  8006a4:	01 c0                	add    %eax,%eax
  8006a6:	01 d0                	add    %edx,%eax
  8006a8:	01 c0                	add    %eax,%eax
  8006aa:	01 d0                	add    %edx,%eax
  8006ac:	89 c2                	mov    %eax,%edx
  8006ae:	c1 e2 05             	shl    $0x5,%edx
  8006b1:	29 c2                	sub    %eax,%edx
  8006b3:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8006ba:	89 c2                	mov    %eax,%edx
  8006bc:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8006c2:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8006cc:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8006d2:	84 c0                	test   %al,%al
  8006d4:	74 0f                	je     8006e5 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8006d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8006db:	05 40 3c 01 00       	add    $0x13c40,%eax
  8006e0:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006e9:	7e 0a                	jle    8006f5 <libmain+0x72>
		binaryname = argv[0];
  8006eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	ff 75 0c             	pushl  0xc(%ebp)
  8006fb:	ff 75 08             	pushl  0x8(%ebp)
  8006fe:	e8 35 f9 ff ff       	call   800038 <_main>
  800703:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800706:	e8 11 16 00 00       	call   801d1c <sys_disable_interrupt>
	cprintf("**************************************\n");
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	68 98 25 80 00       	push   $0x802598
  800713:	e8 84 01 00 00       	call   80089c <cprintf>
  800718:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80071b:	a1 20 30 80 00       	mov    0x803020,%eax
  800720:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800726:	a1 20 30 80 00       	mov    0x803020,%eax
  80072b:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800731:	83 ec 04             	sub    $0x4,%esp
  800734:	52                   	push   %edx
  800735:	50                   	push   %eax
  800736:	68 c0 25 80 00       	push   $0x8025c0
  80073b:	e8 5c 01 00 00       	call   80089c <cprintf>
  800740:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800743:	a1 20 30 80 00       	mov    0x803020,%eax
  800748:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80074e:	a1 20 30 80 00       	mov    0x803020,%eax
  800753:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800759:	83 ec 04             	sub    $0x4,%esp
  80075c:	52                   	push   %edx
  80075d:	50                   	push   %eax
  80075e:	68 e8 25 80 00       	push   $0x8025e8
  800763:	e8 34 01 00 00       	call   80089c <cprintf>
  800768:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80076b:	a1 20 30 80 00       	mov    0x803020,%eax
  800770:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	50                   	push   %eax
  80077a:	68 29 26 80 00       	push   $0x802629
  80077f:	e8 18 01 00 00       	call   80089c <cprintf>
  800784:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800787:	83 ec 0c             	sub    $0xc,%esp
  80078a:	68 98 25 80 00       	push   $0x802598
  80078f:	e8 08 01 00 00       	call   80089c <cprintf>
  800794:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800797:	e8 9a 15 00 00       	call   801d36 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80079c:	e8 19 00 00 00       	call   8007ba <exit>
}
  8007a1:	90                   	nop
  8007a2:	c9                   	leave  
  8007a3:	c3                   	ret    

008007a4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007a4:	55                   	push   %ebp
  8007a5:	89 e5                	mov    %esp,%ebp
  8007a7:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8007aa:	83 ec 0c             	sub    $0xc,%esp
  8007ad:	6a 00                	push   $0x0
  8007af:	e8 99 13 00 00       	call   801b4d <sys_env_destroy>
  8007b4:	83 c4 10             	add    $0x10,%esp
}
  8007b7:	90                   	nop
  8007b8:	c9                   	leave  
  8007b9:	c3                   	ret    

008007ba <exit>:

void
exit(void)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8007c0:	e8 ee 13 00 00       	call   801bb3 <sys_env_exit>
}
  8007c5:	90                   	nop
  8007c6:	c9                   	leave  
  8007c7:	c3                   	ret    

008007c8 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8007c8:	55                   	push   %ebp
  8007c9:	89 e5                	mov    %esp,%ebp
  8007cb:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8007ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	8d 48 01             	lea    0x1(%eax),%ecx
  8007d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d9:	89 0a                	mov    %ecx,(%edx)
  8007db:	8b 55 08             	mov    0x8(%ebp),%edx
  8007de:	88 d1                	mov    %dl,%cl
  8007e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007f1:	75 2c                	jne    80081f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8007f3:	a0 24 30 80 00       	mov    0x803024,%al
  8007f8:	0f b6 c0             	movzbl %al,%eax
  8007fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007fe:	8b 12                	mov    (%edx),%edx
  800800:	89 d1                	mov    %edx,%ecx
  800802:	8b 55 0c             	mov    0xc(%ebp),%edx
  800805:	83 c2 08             	add    $0x8,%edx
  800808:	83 ec 04             	sub    $0x4,%esp
  80080b:	50                   	push   %eax
  80080c:	51                   	push   %ecx
  80080d:	52                   	push   %edx
  80080e:	e8 f8 12 00 00       	call   801b0b <sys_cputs>
  800813:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800816:	8b 45 0c             	mov    0xc(%ebp),%eax
  800819:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80081f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800822:	8b 40 04             	mov    0x4(%eax),%eax
  800825:	8d 50 01             	lea    0x1(%eax),%edx
  800828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80082e:	90                   	nop
  80082f:	c9                   	leave  
  800830:	c3                   	ret    

00800831 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80083a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800841:	00 00 00 
	b.cnt = 0;
  800844:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80084b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	ff 75 08             	pushl  0x8(%ebp)
  800854:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80085a:	50                   	push   %eax
  80085b:	68 c8 07 80 00       	push   $0x8007c8
  800860:	e8 11 02 00 00       	call   800a76 <vprintfmt>
  800865:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800868:	a0 24 30 80 00       	mov    0x803024,%al
  80086d:	0f b6 c0             	movzbl %al,%eax
  800870:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800876:	83 ec 04             	sub    $0x4,%esp
  800879:	50                   	push   %eax
  80087a:	52                   	push   %edx
  80087b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800881:	83 c0 08             	add    $0x8,%eax
  800884:	50                   	push   %eax
  800885:	e8 81 12 00 00       	call   801b0b <sys_cputs>
  80088a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80088d:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800894:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80089a:	c9                   	leave  
  80089b:	c3                   	ret    

0080089c <cprintf>:

int cprintf(const char *fmt, ...) {
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8008a2:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8008a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8008b8:	50                   	push   %eax
  8008b9:	e8 73 ff ff ff       	call   800831 <vcprintf>
  8008be:	83 c4 10             	add    $0x10,%esp
  8008c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8008c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    

008008c9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8008cf:	e8 48 14 00 00       	call   801d1c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8008d4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e3:	50                   	push   %eax
  8008e4:	e8 48 ff ff ff       	call   800831 <vcprintf>
  8008e9:	83 c4 10             	add    $0x10,%esp
  8008ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8008ef:	e8 42 14 00 00       	call   801d36 <sys_enable_interrupt>
	return cnt;
  8008f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008f7:	c9                   	leave  
  8008f8:	c3                   	ret    

008008f9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	53                   	push   %ebx
  8008fd:	83 ec 14             	sub    $0x14,%esp
  800900:	8b 45 10             	mov    0x10(%ebp),%eax
  800903:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800906:	8b 45 14             	mov    0x14(%ebp),%eax
  800909:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80090c:	8b 45 18             	mov    0x18(%ebp),%eax
  80090f:	ba 00 00 00 00       	mov    $0x0,%edx
  800914:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800917:	77 55                	ja     80096e <printnum+0x75>
  800919:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80091c:	72 05                	jb     800923 <printnum+0x2a>
  80091e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800921:	77 4b                	ja     80096e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800923:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800926:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800929:	8b 45 18             	mov    0x18(%ebp),%eax
  80092c:	ba 00 00 00 00       	mov    $0x0,%edx
  800931:	52                   	push   %edx
  800932:	50                   	push   %eax
  800933:	ff 75 f4             	pushl  -0xc(%ebp)
  800936:	ff 75 f0             	pushl  -0x10(%ebp)
  800939:	e8 ce 19 00 00       	call   80230c <__udivdi3>
  80093e:	83 c4 10             	add    $0x10,%esp
  800941:	83 ec 04             	sub    $0x4,%esp
  800944:	ff 75 20             	pushl  0x20(%ebp)
  800947:	53                   	push   %ebx
  800948:	ff 75 18             	pushl  0x18(%ebp)
  80094b:	52                   	push   %edx
  80094c:	50                   	push   %eax
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	ff 75 08             	pushl  0x8(%ebp)
  800953:	e8 a1 ff ff ff       	call   8008f9 <printnum>
  800958:	83 c4 20             	add    $0x20,%esp
  80095b:	eb 1a                	jmp    800977 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	ff 75 0c             	pushl  0xc(%ebp)
  800963:	ff 75 20             	pushl  0x20(%ebp)
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	ff d0                	call   *%eax
  80096b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80096e:	ff 4d 1c             	decl   0x1c(%ebp)
  800971:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800975:	7f e6                	jg     80095d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800977:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80097a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80097f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800982:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800985:	53                   	push   %ebx
  800986:	51                   	push   %ecx
  800987:	52                   	push   %edx
  800988:	50                   	push   %eax
  800989:	e8 8e 1a 00 00       	call   80241c <__umoddi3>
  80098e:	83 c4 10             	add    $0x10,%esp
  800991:	05 54 28 80 00       	add    $0x802854,%eax
  800996:	8a 00                	mov    (%eax),%al
  800998:	0f be c0             	movsbl %al,%eax
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	50                   	push   %eax
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	ff d0                	call   *%eax
  8009a7:	83 c4 10             	add    $0x10,%esp
}
  8009aa:	90                   	nop
  8009ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ae:	c9                   	leave  
  8009af:	c3                   	ret    

008009b0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009b7:	7e 1c                	jle    8009d5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	8b 00                	mov    (%eax),%eax
  8009be:	8d 50 08             	lea    0x8(%eax),%edx
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	89 10                	mov    %edx,(%eax)
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	8b 00                	mov    (%eax),%eax
  8009cb:	83 e8 08             	sub    $0x8,%eax
  8009ce:	8b 50 04             	mov    0x4(%eax),%edx
  8009d1:	8b 00                	mov    (%eax),%eax
  8009d3:	eb 40                	jmp    800a15 <getuint+0x65>
	else if (lflag)
  8009d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009d9:	74 1e                	je     8009f9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	8b 00                	mov    (%eax),%eax
  8009e0:	8d 50 04             	lea    0x4(%eax),%edx
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	89 10                	mov    %edx,(%eax)
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	83 e8 04             	sub    $0x4,%eax
  8009f0:	8b 00                	mov    (%eax),%eax
  8009f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f7:	eb 1c                	jmp    800a15 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	8b 00                	mov    (%eax),%eax
  8009fe:	8d 50 04             	lea    0x4(%eax),%edx
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	89 10                	mov    %edx,(%eax)
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	8b 00                	mov    (%eax),%eax
  800a0b:	83 e8 04             	sub    $0x4,%eax
  800a0e:	8b 00                	mov    (%eax),%eax
  800a10:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    

00800a17 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a1a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a1e:	7e 1c                	jle    800a3c <getint+0x25>
		return va_arg(*ap, long long);
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	8b 00                	mov    (%eax),%eax
  800a25:	8d 50 08             	lea    0x8(%eax),%edx
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	89 10                	mov    %edx,(%eax)
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	8b 00                	mov    (%eax),%eax
  800a32:	83 e8 08             	sub    $0x8,%eax
  800a35:	8b 50 04             	mov    0x4(%eax),%edx
  800a38:	8b 00                	mov    (%eax),%eax
  800a3a:	eb 38                	jmp    800a74 <getint+0x5d>
	else if (lflag)
  800a3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a40:	74 1a                	je     800a5c <getint+0x45>
		return va_arg(*ap, long);
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	8b 00                	mov    (%eax),%eax
  800a47:	8d 50 04             	lea    0x4(%eax),%edx
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	89 10                	mov    %edx,(%eax)
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	8b 00                	mov    (%eax),%eax
  800a54:	83 e8 04             	sub    $0x4,%eax
  800a57:	8b 00                	mov    (%eax),%eax
  800a59:	99                   	cltd   
  800a5a:	eb 18                	jmp    800a74 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8b 00                	mov    (%eax),%eax
  800a61:	8d 50 04             	lea    0x4(%eax),%edx
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	89 10                	mov    %edx,(%eax)
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8b 00                	mov    (%eax),%eax
  800a6e:	83 e8 04             	sub    $0x4,%eax
  800a71:	8b 00                	mov    (%eax),%eax
  800a73:	99                   	cltd   
}
  800a74:	5d                   	pop    %ebp
  800a75:	c3                   	ret    

00800a76 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	56                   	push   %esi
  800a7a:	53                   	push   %ebx
  800a7b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a7e:	eb 17                	jmp    800a97 <vprintfmt+0x21>
			if (ch == '\0')
  800a80:	85 db                	test   %ebx,%ebx
  800a82:	0f 84 af 03 00 00    	je     800e37 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	53                   	push   %ebx
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	ff d0                	call   *%eax
  800a94:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a97:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9a:	8d 50 01             	lea    0x1(%eax),%edx
  800a9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800aa0:	8a 00                	mov    (%eax),%al
  800aa2:	0f b6 d8             	movzbl %al,%ebx
  800aa5:	83 fb 25             	cmp    $0x25,%ebx
  800aa8:	75 d6                	jne    800a80 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800aaa:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800aae:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ab5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800abc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ac3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800aca:	8b 45 10             	mov    0x10(%ebp),%eax
  800acd:	8d 50 01             	lea    0x1(%eax),%edx
  800ad0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ad3:	8a 00                	mov    (%eax),%al
  800ad5:	0f b6 d8             	movzbl %al,%ebx
  800ad8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800adb:	83 f8 55             	cmp    $0x55,%eax
  800ade:	0f 87 2b 03 00 00    	ja     800e0f <vprintfmt+0x399>
  800ae4:	8b 04 85 78 28 80 00 	mov    0x802878(,%eax,4),%eax
  800aeb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800aed:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800af1:	eb d7                	jmp    800aca <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800af3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800af7:	eb d1                	jmp    800aca <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800af9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800b00:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b03:	89 d0                	mov    %edx,%eax
  800b05:	c1 e0 02             	shl    $0x2,%eax
  800b08:	01 d0                	add    %edx,%eax
  800b0a:	01 c0                	add    %eax,%eax
  800b0c:	01 d8                	add    %ebx,%eax
  800b0e:	83 e8 30             	sub    $0x30,%eax
  800b11:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800b14:	8b 45 10             	mov    0x10(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b1c:	83 fb 2f             	cmp    $0x2f,%ebx
  800b1f:	7e 3e                	jle    800b5f <vprintfmt+0xe9>
  800b21:	83 fb 39             	cmp    $0x39,%ebx
  800b24:	7f 39                	jg     800b5f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b26:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b29:	eb d5                	jmp    800b00 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2e:	83 c0 04             	add    $0x4,%eax
  800b31:	89 45 14             	mov    %eax,0x14(%ebp)
  800b34:	8b 45 14             	mov    0x14(%ebp),%eax
  800b37:	83 e8 04             	sub    $0x4,%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b3f:	eb 1f                	jmp    800b60 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b45:	79 83                	jns    800aca <vprintfmt+0x54>
				width = 0;
  800b47:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b4e:	e9 77 ff ff ff       	jmp    800aca <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b53:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b5a:	e9 6b ff ff ff       	jmp    800aca <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b5f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b60:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b64:	0f 89 60 ff ff ff    	jns    800aca <vprintfmt+0x54>
				width = precision, precision = -1;
  800b6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b70:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b77:	e9 4e ff ff ff       	jmp    800aca <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b7c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b7f:	e9 46 ff ff ff       	jmp    800aca <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b84:	8b 45 14             	mov    0x14(%ebp),%eax
  800b87:	83 c0 04             	add    $0x4,%eax
  800b8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b90:	83 e8 04             	sub    $0x4,%eax
  800b93:	8b 00                	mov    (%eax),%eax
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	50                   	push   %eax
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	ff d0                	call   *%eax
  800ba1:	83 c4 10             	add    $0x10,%esp
			break;
  800ba4:	e9 89 02 00 00       	jmp    800e32 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ba9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bac:	83 c0 04             	add    $0x4,%eax
  800baf:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb5:	83 e8 04             	sub    $0x4,%eax
  800bb8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800bba:	85 db                	test   %ebx,%ebx
  800bbc:	79 02                	jns    800bc0 <vprintfmt+0x14a>
				err = -err;
  800bbe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800bc0:	83 fb 64             	cmp    $0x64,%ebx
  800bc3:	7f 0b                	jg     800bd0 <vprintfmt+0x15a>
  800bc5:	8b 34 9d c0 26 80 00 	mov    0x8026c0(,%ebx,4),%esi
  800bcc:	85 f6                	test   %esi,%esi
  800bce:	75 19                	jne    800be9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800bd0:	53                   	push   %ebx
  800bd1:	68 65 28 80 00       	push   $0x802865
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	ff 75 08             	pushl  0x8(%ebp)
  800bdc:	e8 5e 02 00 00       	call   800e3f <printfmt>
  800be1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800be4:	e9 49 02 00 00       	jmp    800e32 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800be9:	56                   	push   %esi
  800bea:	68 6e 28 80 00       	push   $0x80286e
  800bef:	ff 75 0c             	pushl  0xc(%ebp)
  800bf2:	ff 75 08             	pushl  0x8(%ebp)
  800bf5:	e8 45 02 00 00       	call   800e3f <printfmt>
  800bfa:	83 c4 10             	add    $0x10,%esp
			break;
  800bfd:	e9 30 02 00 00       	jmp    800e32 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800c02:	8b 45 14             	mov    0x14(%ebp),%eax
  800c05:	83 c0 04             	add    $0x4,%eax
  800c08:	89 45 14             	mov    %eax,0x14(%ebp)
  800c0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0e:	83 e8 04             	sub    $0x4,%eax
  800c11:	8b 30                	mov    (%eax),%esi
  800c13:	85 f6                	test   %esi,%esi
  800c15:	75 05                	jne    800c1c <vprintfmt+0x1a6>
				p = "(null)";
  800c17:	be 71 28 80 00       	mov    $0x802871,%esi
			if (width > 0 && padc != '-')
  800c1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c20:	7e 6d                	jle    800c8f <vprintfmt+0x219>
  800c22:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800c26:	74 67                	je     800c8f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c2b:	83 ec 08             	sub    $0x8,%esp
  800c2e:	50                   	push   %eax
  800c2f:	56                   	push   %esi
  800c30:	e8 0c 03 00 00       	call   800f41 <strnlen>
  800c35:	83 c4 10             	add    $0x10,%esp
  800c38:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c3b:	eb 16                	jmp    800c53 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c3d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c41:	83 ec 08             	sub    $0x8,%esp
  800c44:	ff 75 0c             	pushl  0xc(%ebp)
  800c47:	50                   	push   %eax
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	ff d0                	call   *%eax
  800c4d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c50:	ff 4d e4             	decl   -0x1c(%ebp)
  800c53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c57:	7f e4                	jg     800c3d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c59:	eb 34                	jmp    800c8f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c5f:	74 1c                	je     800c7d <vprintfmt+0x207>
  800c61:	83 fb 1f             	cmp    $0x1f,%ebx
  800c64:	7e 05                	jle    800c6b <vprintfmt+0x1f5>
  800c66:	83 fb 7e             	cmp    $0x7e,%ebx
  800c69:	7e 12                	jle    800c7d <vprintfmt+0x207>
					putch('?', putdat);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	6a 3f                	push   $0x3f
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	ff d0                	call   *%eax
  800c78:	83 c4 10             	add    $0x10,%esp
  800c7b:	eb 0f                	jmp    800c8c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c7d:	83 ec 08             	sub    $0x8,%esp
  800c80:	ff 75 0c             	pushl  0xc(%ebp)
  800c83:	53                   	push   %ebx
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	ff d0                	call   *%eax
  800c89:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c8c:	ff 4d e4             	decl   -0x1c(%ebp)
  800c8f:	89 f0                	mov    %esi,%eax
  800c91:	8d 70 01             	lea    0x1(%eax),%esi
  800c94:	8a 00                	mov    (%eax),%al
  800c96:	0f be d8             	movsbl %al,%ebx
  800c99:	85 db                	test   %ebx,%ebx
  800c9b:	74 24                	je     800cc1 <vprintfmt+0x24b>
  800c9d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ca1:	78 b8                	js     800c5b <vprintfmt+0x1e5>
  800ca3:	ff 4d e0             	decl   -0x20(%ebp)
  800ca6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800caa:	79 af                	jns    800c5b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cac:	eb 13                	jmp    800cc1 <vprintfmt+0x24b>
				putch(' ', putdat);
  800cae:	83 ec 08             	sub    $0x8,%esp
  800cb1:	ff 75 0c             	pushl  0xc(%ebp)
  800cb4:	6a 20                	push   $0x20
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	ff d0                	call   *%eax
  800cbb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cbe:	ff 4d e4             	decl   -0x1c(%ebp)
  800cc1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cc5:	7f e7                	jg     800cae <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800cc7:	e9 66 01 00 00       	jmp    800e32 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ccc:	83 ec 08             	sub    $0x8,%esp
  800ccf:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd2:	8d 45 14             	lea    0x14(%ebp),%eax
  800cd5:	50                   	push   %eax
  800cd6:	e8 3c fd ff ff       	call   800a17 <getint>
  800cdb:	83 c4 10             	add    $0x10,%esp
  800cde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ce7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cea:	85 d2                	test   %edx,%edx
  800cec:	79 23                	jns    800d11 <vprintfmt+0x29b>
				putch('-', putdat);
  800cee:	83 ec 08             	sub    $0x8,%esp
  800cf1:	ff 75 0c             	pushl  0xc(%ebp)
  800cf4:	6a 2d                	push   $0x2d
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	ff d0                	call   *%eax
  800cfb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d04:	f7 d8                	neg    %eax
  800d06:	83 d2 00             	adc    $0x0,%edx
  800d09:	f7 da                	neg    %edx
  800d0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800d11:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d18:	e9 bc 00 00 00       	jmp    800dd9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d1d:	83 ec 08             	sub    $0x8,%esp
  800d20:	ff 75 e8             	pushl  -0x18(%ebp)
  800d23:	8d 45 14             	lea    0x14(%ebp),%eax
  800d26:	50                   	push   %eax
  800d27:	e8 84 fc ff ff       	call   8009b0 <getuint>
  800d2c:	83 c4 10             	add    $0x10,%esp
  800d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d32:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d35:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d3c:	e9 98 00 00 00       	jmp    800dd9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d41:	83 ec 08             	sub    $0x8,%esp
  800d44:	ff 75 0c             	pushl  0xc(%ebp)
  800d47:	6a 58                	push   $0x58
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	ff d0                	call   *%eax
  800d4e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d51:	83 ec 08             	sub    $0x8,%esp
  800d54:	ff 75 0c             	pushl  0xc(%ebp)
  800d57:	6a 58                	push   $0x58
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	ff d0                	call   *%eax
  800d5e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d61:	83 ec 08             	sub    $0x8,%esp
  800d64:	ff 75 0c             	pushl  0xc(%ebp)
  800d67:	6a 58                	push   $0x58
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	ff d0                	call   *%eax
  800d6e:	83 c4 10             	add    $0x10,%esp
			break;
  800d71:	e9 bc 00 00 00       	jmp    800e32 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d76:	83 ec 08             	sub    $0x8,%esp
  800d79:	ff 75 0c             	pushl  0xc(%ebp)
  800d7c:	6a 30                	push   $0x30
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d86:	83 ec 08             	sub    $0x8,%esp
  800d89:	ff 75 0c             	pushl  0xc(%ebp)
  800d8c:	6a 78                	push   $0x78
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	ff d0                	call   *%eax
  800d93:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d96:	8b 45 14             	mov    0x14(%ebp),%eax
  800d99:	83 c0 04             	add    $0x4,%eax
  800d9c:	89 45 14             	mov    %eax,0x14(%ebp)
  800d9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800da2:	83 e8 04             	sub    $0x4,%eax
  800da5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800da7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800daa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800db1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800db8:	eb 1f                	jmp    800dd9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800dba:	83 ec 08             	sub    $0x8,%esp
  800dbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800dc0:	8d 45 14             	lea    0x14(%ebp),%eax
  800dc3:	50                   	push   %eax
  800dc4:	e8 e7 fb ff ff       	call   8009b0 <getuint>
  800dc9:	83 c4 10             	add    $0x10,%esp
  800dcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800dd2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800dd9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ddd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	52                   	push   %edx
  800de4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800de7:	50                   	push   %eax
  800de8:	ff 75 f4             	pushl  -0xc(%ebp)
  800deb:	ff 75 f0             	pushl  -0x10(%ebp)
  800dee:	ff 75 0c             	pushl  0xc(%ebp)
  800df1:	ff 75 08             	pushl  0x8(%ebp)
  800df4:	e8 00 fb ff ff       	call   8008f9 <printnum>
  800df9:	83 c4 20             	add    $0x20,%esp
			break;
  800dfc:	eb 34                	jmp    800e32 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dfe:	83 ec 08             	sub    $0x8,%esp
  800e01:	ff 75 0c             	pushl  0xc(%ebp)
  800e04:	53                   	push   %ebx
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	ff d0                	call   *%eax
  800e0a:	83 c4 10             	add    $0x10,%esp
			break;
  800e0d:	eb 23                	jmp    800e32 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e0f:	83 ec 08             	sub    $0x8,%esp
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	6a 25                	push   $0x25
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	ff d0                	call   *%eax
  800e1c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e1f:	ff 4d 10             	decl   0x10(%ebp)
  800e22:	eb 03                	jmp    800e27 <vprintfmt+0x3b1>
  800e24:	ff 4d 10             	decl   0x10(%ebp)
  800e27:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2a:	48                   	dec    %eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	3c 25                	cmp    $0x25,%al
  800e2f:	75 f3                	jne    800e24 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800e31:	90                   	nop
		}
	}
  800e32:	e9 47 fc ff ff       	jmp    800a7e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e37:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e3b:	5b                   	pop    %ebx
  800e3c:	5e                   	pop    %esi
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    

00800e3f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e45:	8d 45 10             	lea    0x10(%ebp),%eax
  800e48:	83 c0 04             	add    $0x4,%eax
  800e4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e51:	ff 75 f4             	pushl  -0xc(%ebp)
  800e54:	50                   	push   %eax
  800e55:	ff 75 0c             	pushl  0xc(%ebp)
  800e58:	ff 75 08             	pushl  0x8(%ebp)
  800e5b:	e8 16 fc ff ff       	call   800a76 <vprintfmt>
  800e60:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e63:	90                   	nop
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	8b 40 08             	mov    0x8(%eax),%eax
  800e6f:	8d 50 01             	lea    0x1(%eax),%edx
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7b:	8b 10                	mov    (%eax),%edx
  800e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e80:	8b 40 04             	mov    0x4(%eax),%eax
  800e83:	39 c2                	cmp    %eax,%edx
  800e85:	73 12                	jae    800e99 <sprintputch+0x33>
		*b->buf++ = ch;
  800e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8a:	8b 00                	mov    (%eax),%eax
  800e8c:	8d 48 01             	lea    0x1(%eax),%ecx
  800e8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e92:	89 0a                	mov    %ecx,(%edx)
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	88 10                	mov    %dl,(%eax)
}
  800e99:	90                   	nop
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    

00800e9c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	01 d0                	add    %edx,%eax
  800eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ebd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ec1:	74 06                	je     800ec9 <vsnprintf+0x2d>
  800ec3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ec7:	7f 07                	jg     800ed0 <vsnprintf+0x34>
		return -E_INVAL;
  800ec9:	b8 03 00 00 00       	mov    $0x3,%eax
  800ece:	eb 20                	jmp    800ef0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ed0:	ff 75 14             	pushl  0x14(%ebp)
  800ed3:	ff 75 10             	pushl  0x10(%ebp)
  800ed6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ed9:	50                   	push   %eax
  800eda:	68 66 0e 80 00       	push   $0x800e66
  800edf:	e8 92 fb ff ff       	call   800a76 <vprintfmt>
  800ee4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ee7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eea:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ef0:	c9                   	leave  
  800ef1:	c3                   	ret    

00800ef2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ef8:	8d 45 10             	lea    0x10(%ebp),%eax
  800efb:	83 c0 04             	add    $0x4,%eax
  800efe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800f01:	8b 45 10             	mov    0x10(%ebp),%eax
  800f04:	ff 75 f4             	pushl  -0xc(%ebp)
  800f07:	50                   	push   %eax
  800f08:	ff 75 0c             	pushl  0xc(%ebp)
  800f0b:	ff 75 08             	pushl  0x8(%ebp)
  800f0e:	e8 89 ff ff ff       	call   800e9c <vsnprintf>
  800f13:	83 c4 10             	add    $0x10,%esp
  800f16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f1c:	c9                   	leave  
  800f1d:	c3                   	ret    

00800f1e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f2b:	eb 06                	jmp    800f33 <strlen+0x15>
		n++;
  800f2d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f30:	ff 45 08             	incl   0x8(%ebp)
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	84 c0                	test   %al,%al
  800f3a:	75 f1                	jne    800f2d <strlen+0xf>
		n++;
	return n;
  800f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f4e:	eb 09                	jmp    800f59 <strnlen+0x18>
		n++;
  800f50:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f53:	ff 45 08             	incl   0x8(%ebp)
  800f56:	ff 4d 0c             	decl   0xc(%ebp)
  800f59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f5d:	74 09                	je     800f68 <strnlen+0x27>
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	84 c0                	test   %al,%al
  800f66:	75 e8                	jne    800f50 <strnlen+0xf>
		n++;
	return n;
  800f68:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f6b:	c9                   	leave  
  800f6c:	c3                   	ret    

00800f6d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f79:	90                   	nop
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	8d 50 01             	lea    0x1(%eax),%edx
  800f80:	89 55 08             	mov    %edx,0x8(%ebp)
  800f83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f86:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f89:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f8c:	8a 12                	mov    (%edx),%dl
  800f8e:	88 10                	mov    %dl,(%eax)
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	84 c0                	test   %al,%al
  800f94:	75 e4                	jne    800f7a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

00800f9b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800fa7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fae:	eb 1f                	jmp    800fcf <strncpy+0x34>
		*dst++ = *src;
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8d 50 01             	lea    0x1(%eax),%edx
  800fb6:	89 55 08             	mov    %edx,0x8(%ebp)
  800fb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fbc:	8a 12                	mov    (%edx),%dl
  800fbe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	84 c0                	test   %al,%al
  800fc7:	74 03                	je     800fcc <strncpy+0x31>
			src++;
  800fc9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fcc:	ff 45 fc             	incl   -0x4(%ebp)
  800fcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fd5:	72 d9                	jb     800fb0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800fe8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fec:	74 30                	je     80101e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fee:	eb 16                	jmp    801006 <strlcpy+0x2a>
			*dst++ = *src++;
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8d 50 01             	lea    0x1(%eax),%edx
  800ff6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ff9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ffc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801002:	8a 12                	mov    (%edx),%dl
  801004:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801006:	ff 4d 10             	decl   0x10(%ebp)
  801009:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100d:	74 09                	je     801018 <strlcpy+0x3c>
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	84 c0                	test   %al,%al
  801016:	75 d8                	jne    800ff0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80101e:	8b 55 08             	mov    0x8(%ebp),%edx
  801021:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801024:	29 c2                	sub    %eax,%edx
  801026:	89 d0                	mov    %edx,%eax
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80102d:	eb 06                	jmp    801035 <strcmp+0xb>
		p++, q++;
  80102f:	ff 45 08             	incl   0x8(%ebp)
  801032:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	84 c0                	test   %al,%al
  80103c:	74 0e                	je     80104c <strcmp+0x22>
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	8a 10                	mov    (%eax),%dl
  801043:	8b 45 0c             	mov    0xc(%ebp),%eax
  801046:	8a 00                	mov    (%eax),%al
  801048:	38 c2                	cmp    %al,%dl
  80104a:	74 e3                	je     80102f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	0f b6 d0             	movzbl %al,%edx
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	0f b6 c0             	movzbl %al,%eax
  80105c:	29 c2                	sub    %eax,%edx
  80105e:	89 d0                	mov    %edx,%eax
}
  801060:	5d                   	pop    %ebp
  801061:	c3                   	ret    

00801062 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801065:	eb 09                	jmp    801070 <strncmp+0xe>
		n--, p++, q++;
  801067:	ff 4d 10             	decl   0x10(%ebp)
  80106a:	ff 45 08             	incl   0x8(%ebp)
  80106d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801070:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801074:	74 17                	je     80108d <strncmp+0x2b>
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	84 c0                	test   %al,%al
  80107d:	74 0e                	je     80108d <strncmp+0x2b>
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 10                	mov    (%eax),%dl
  801084:	8b 45 0c             	mov    0xc(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	38 c2                	cmp    %al,%dl
  80108b:	74 da                	je     801067 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80108d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801091:	75 07                	jne    80109a <strncmp+0x38>
		return 0;
  801093:	b8 00 00 00 00       	mov    $0x0,%eax
  801098:	eb 14                	jmp    8010ae <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	0f b6 d0             	movzbl %al,%edx
  8010a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a5:	8a 00                	mov    (%eax),%al
  8010a7:	0f b6 c0             	movzbl %al,%eax
  8010aa:	29 c2                	sub    %eax,%edx
  8010ac:	89 d0                	mov    %edx,%eax
}
  8010ae:	5d                   	pop    %ebp
  8010af:	c3                   	ret    

008010b0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	83 ec 04             	sub    $0x4,%esp
  8010b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010bc:	eb 12                	jmp    8010d0 <strchr+0x20>
		if (*s == c)
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010c6:	75 05                	jne    8010cd <strchr+0x1d>
			return (char *) s;
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	eb 11                	jmp    8010de <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010cd:	ff 45 08             	incl   0x8(%ebp)
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	84 c0                	test   %al,%al
  8010d7:	75 e5                	jne    8010be <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010de:	c9                   	leave  
  8010df:	c3                   	ret    

008010e0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 04             	sub    $0x4,%esp
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010ec:	eb 0d                	jmp    8010fb <strfind+0x1b>
		if (*s == c)
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8a 00                	mov    (%eax),%al
  8010f3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010f6:	74 0e                	je     801106 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010f8:	ff 45 08             	incl   0x8(%ebp)
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	84 c0                	test   %al,%al
  801102:	75 ea                	jne    8010ee <strfind+0xe>
  801104:	eb 01                	jmp    801107 <strfind+0x27>
		if (*s == c)
			break;
  801106:	90                   	nop
	return (char *) s;
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801118:	8b 45 10             	mov    0x10(%ebp),%eax
  80111b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80111e:	eb 0e                	jmp    80112e <memset+0x22>
		*p++ = c;
  801120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801123:	8d 50 01             	lea    0x1(%eax),%edx
  801126:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801129:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80112e:	ff 4d f8             	decl   -0x8(%ebp)
  801131:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801135:	79 e9                	jns    801120 <memset+0x14>
		*p++ = c;

	return v;
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113a:	c9                   	leave  
  80113b:	c3                   	ret    

0080113c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80114e:	eb 16                	jmp    801166 <memcpy+0x2a>
		*d++ = *s++;
  801150:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801153:	8d 50 01             	lea    0x1(%eax),%edx
  801156:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801159:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80115f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801162:	8a 12                	mov    (%edx),%dl
  801164:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	8d 50 ff             	lea    -0x1(%eax),%edx
  80116c:	89 55 10             	mov    %edx,0x10(%ebp)
  80116f:	85 c0                	test   %eax,%eax
  801171:	75 dd                	jne    801150 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801176:	c9                   	leave  
  801177:	c3                   	ret    

00801178 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80117e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801181:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80118a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801190:	73 50                	jae    8011e2 <memmove+0x6a>
  801192:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801195:	8b 45 10             	mov    0x10(%ebp),%eax
  801198:	01 d0                	add    %edx,%eax
  80119a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80119d:	76 43                	jbe    8011e2 <memmove+0x6a>
		s += n;
  80119f:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8011a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011ab:	eb 10                	jmp    8011bd <memmove+0x45>
			*--d = *--s;
  8011ad:	ff 4d f8             	decl   -0x8(%ebp)
  8011b0:	ff 4d fc             	decl   -0x4(%ebp)
  8011b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b6:	8a 10                	mov    (%eax),%dl
  8011b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8011bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c3:	89 55 10             	mov    %edx,0x10(%ebp)
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	75 e3                	jne    8011ad <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011ca:	eb 23                	jmp    8011ef <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cf:	8d 50 01             	lea    0x1(%eax),%edx
  8011d2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011db:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011de:	8a 12                	mov    (%edx),%dl
  8011e0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8011eb:	85 c0                	test   %eax,%eax
  8011ed:	75 dd                	jne    8011cc <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    

008011f4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801200:	8b 45 0c             	mov    0xc(%ebp),%eax
  801203:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801206:	eb 2a                	jmp    801232 <memcmp+0x3e>
		if (*s1 != *s2)
  801208:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80120b:	8a 10                	mov    (%eax),%dl
  80120d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	38 c2                	cmp    %al,%dl
  801214:	74 16                	je     80122c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801216:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801219:	8a 00                	mov    (%eax),%al
  80121b:	0f b6 d0             	movzbl %al,%edx
  80121e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	0f b6 c0             	movzbl %al,%eax
  801226:	29 c2                	sub    %eax,%edx
  801228:	89 d0                	mov    %edx,%eax
  80122a:	eb 18                	jmp    801244 <memcmp+0x50>
		s1++, s2++;
  80122c:	ff 45 fc             	incl   -0x4(%ebp)
  80122f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801232:	8b 45 10             	mov    0x10(%ebp),%eax
  801235:	8d 50 ff             	lea    -0x1(%eax),%edx
  801238:	89 55 10             	mov    %edx,0x10(%ebp)
  80123b:	85 c0                	test   %eax,%eax
  80123d:	75 c9                	jne    801208 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80123f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801244:	c9                   	leave  
  801245:	c3                   	ret    

00801246 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80124c:	8b 55 08             	mov    0x8(%ebp),%edx
  80124f:	8b 45 10             	mov    0x10(%ebp),%eax
  801252:	01 d0                	add    %edx,%eax
  801254:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801257:	eb 15                	jmp    80126e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	0f b6 d0             	movzbl %al,%edx
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	0f b6 c0             	movzbl %al,%eax
  801267:	39 c2                	cmp    %eax,%edx
  801269:	74 0d                	je     801278 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80126b:	ff 45 08             	incl   0x8(%ebp)
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801274:	72 e3                	jb     801259 <memfind+0x13>
  801276:	eb 01                	jmp    801279 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801278:	90                   	nop
	return (void *) s;
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80127c:	c9                   	leave  
  80127d:	c3                   	ret    

0080127e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801284:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80128b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801292:	eb 03                	jmp    801297 <strtol+0x19>
		s++;
  801294:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	3c 20                	cmp    $0x20,%al
  80129e:	74 f4                	je     801294 <strtol+0x16>
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	3c 09                	cmp    $0x9,%al
  8012a7:	74 eb                	je     801294 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	8a 00                	mov    (%eax),%al
  8012ae:	3c 2b                	cmp    $0x2b,%al
  8012b0:	75 05                	jne    8012b7 <strtol+0x39>
		s++;
  8012b2:	ff 45 08             	incl   0x8(%ebp)
  8012b5:	eb 13                	jmp    8012ca <strtol+0x4c>
	else if (*s == '-')
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	3c 2d                	cmp    $0x2d,%al
  8012be:	75 0a                	jne    8012ca <strtol+0x4c>
		s++, neg = 1;
  8012c0:	ff 45 08             	incl   0x8(%ebp)
  8012c3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ce:	74 06                	je     8012d6 <strtol+0x58>
  8012d0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012d4:	75 20                	jne    8012f6 <strtol+0x78>
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	3c 30                	cmp    $0x30,%al
  8012dd:	75 17                	jne    8012f6 <strtol+0x78>
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	40                   	inc    %eax
  8012e3:	8a 00                	mov    (%eax),%al
  8012e5:	3c 78                	cmp    $0x78,%al
  8012e7:	75 0d                	jne    8012f6 <strtol+0x78>
		s += 2, base = 16;
  8012e9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012ed:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012f4:	eb 28                	jmp    80131e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012fa:	75 15                	jne    801311 <strtol+0x93>
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	3c 30                	cmp    $0x30,%al
  801303:	75 0c                	jne    801311 <strtol+0x93>
		s++, base = 8;
  801305:	ff 45 08             	incl   0x8(%ebp)
  801308:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80130f:	eb 0d                	jmp    80131e <strtol+0xa0>
	else if (base == 0)
  801311:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801315:	75 07                	jne    80131e <strtol+0xa0>
		base = 10;
  801317:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	8a 00                	mov    (%eax),%al
  801323:	3c 2f                	cmp    $0x2f,%al
  801325:	7e 19                	jle    801340 <strtol+0xc2>
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	8a 00                	mov    (%eax),%al
  80132c:	3c 39                	cmp    $0x39,%al
  80132e:	7f 10                	jg     801340 <strtol+0xc2>
			dig = *s - '0';
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	8a 00                	mov    (%eax),%al
  801335:	0f be c0             	movsbl %al,%eax
  801338:	83 e8 30             	sub    $0x30,%eax
  80133b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80133e:	eb 42                	jmp    801382 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	3c 60                	cmp    $0x60,%al
  801347:	7e 19                	jle    801362 <strtol+0xe4>
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 00                	mov    (%eax),%al
  80134e:	3c 7a                	cmp    $0x7a,%al
  801350:	7f 10                	jg     801362 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	0f be c0             	movsbl %al,%eax
  80135a:	83 e8 57             	sub    $0x57,%eax
  80135d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801360:	eb 20                	jmp    801382 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 00                	mov    (%eax),%al
  801367:	3c 40                	cmp    $0x40,%al
  801369:	7e 39                	jle    8013a4 <strtol+0x126>
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	8a 00                	mov    (%eax),%al
  801370:	3c 5a                	cmp    $0x5a,%al
  801372:	7f 30                	jg     8013a4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	8a 00                	mov    (%eax),%al
  801379:	0f be c0             	movsbl %al,%eax
  80137c:	83 e8 37             	sub    $0x37,%eax
  80137f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801385:	3b 45 10             	cmp    0x10(%ebp),%eax
  801388:	7d 19                	jge    8013a3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80138a:	ff 45 08             	incl   0x8(%ebp)
  80138d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801390:	0f af 45 10          	imul   0x10(%ebp),%eax
  801394:	89 c2                	mov    %eax,%edx
  801396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801399:	01 d0                	add    %edx,%eax
  80139b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80139e:	e9 7b ff ff ff       	jmp    80131e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8013a3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8013a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013a8:	74 08                	je     8013b2 <strtol+0x134>
		*endptr = (char *) s;
  8013aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8013b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013b6:	74 07                	je     8013bf <strtol+0x141>
  8013b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013bb:	f7 d8                	neg    %eax
  8013bd:	eb 03                	jmp    8013c2 <strtol+0x144>
  8013bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013c2:	c9                   	leave  
  8013c3:	c3                   	ret    

008013c4 <ltostr>:

void
ltostr(long value, char *str)
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
  8013c7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013dc:	79 13                	jns    8013f1 <ltostr+0x2d>
	{
		neg = 1;
  8013de:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013eb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013ee:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013f9:	99                   	cltd   
  8013fa:	f7 f9                	idiv   %ecx
  8013fc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801402:	8d 50 01             	lea    0x1(%eax),%edx
  801405:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801408:	89 c2                	mov    %eax,%edx
  80140a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140d:	01 d0                	add    %edx,%eax
  80140f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801412:	83 c2 30             	add    $0x30,%edx
  801415:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801417:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80141a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80141f:	f7 e9                	imul   %ecx
  801421:	c1 fa 02             	sar    $0x2,%edx
  801424:	89 c8                	mov    %ecx,%eax
  801426:	c1 f8 1f             	sar    $0x1f,%eax
  801429:	29 c2                	sub    %eax,%edx
  80142b:	89 d0                	mov    %edx,%eax
  80142d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801430:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801433:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801438:	f7 e9                	imul   %ecx
  80143a:	c1 fa 02             	sar    $0x2,%edx
  80143d:	89 c8                	mov    %ecx,%eax
  80143f:	c1 f8 1f             	sar    $0x1f,%eax
  801442:	29 c2                	sub    %eax,%edx
  801444:	89 d0                	mov    %edx,%eax
  801446:	c1 e0 02             	shl    $0x2,%eax
  801449:	01 d0                	add    %edx,%eax
  80144b:	01 c0                	add    %eax,%eax
  80144d:	29 c1                	sub    %eax,%ecx
  80144f:	89 ca                	mov    %ecx,%edx
  801451:	85 d2                	test   %edx,%edx
  801453:	75 9c                	jne    8013f1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801455:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80145c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145f:	48                   	dec    %eax
  801460:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801463:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801467:	74 3d                	je     8014a6 <ltostr+0xe2>
		start = 1 ;
  801469:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801470:	eb 34                	jmp    8014a6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801472:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801475:	8b 45 0c             	mov    0xc(%ebp),%eax
  801478:	01 d0                	add    %edx,%eax
  80147a:	8a 00                	mov    (%eax),%al
  80147c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80147f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	01 c2                	add    %eax,%edx
  801487:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80148a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148d:	01 c8                	add    %ecx,%eax
  80148f:	8a 00                	mov    (%eax),%al
  801491:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801493:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801496:	8b 45 0c             	mov    0xc(%ebp),%eax
  801499:	01 c2                	add    %eax,%edx
  80149b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80149e:	88 02                	mov    %al,(%edx)
		start++ ;
  8014a0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8014a3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8014a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014ac:	7c c4                	jl     801472 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8014ae:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8014b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b4:	01 d0                	add    %edx,%eax
  8014b6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8014b9:	90                   	nop
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8014c2:	ff 75 08             	pushl  0x8(%ebp)
  8014c5:	e8 54 fa ff ff       	call   800f1e <strlen>
  8014ca:	83 c4 04             	add    $0x4,%esp
  8014cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8014d0:	ff 75 0c             	pushl  0xc(%ebp)
  8014d3:	e8 46 fa ff ff       	call   800f1e <strlen>
  8014d8:	83 c4 04             	add    $0x4,%esp
  8014db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014ec:	eb 17                	jmp    801505 <strcconcat+0x49>
		final[s] = str1[s] ;
  8014ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f4:	01 c2                	add    %eax,%edx
  8014f6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	01 c8                	add    %ecx,%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801502:	ff 45 fc             	incl   -0x4(%ebp)
  801505:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801508:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80150b:	7c e1                	jl     8014ee <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80150d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801514:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80151b:	eb 1f                	jmp    80153c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80151d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801520:	8d 50 01             	lea    0x1(%eax),%edx
  801523:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801526:	89 c2                	mov    %eax,%edx
  801528:	8b 45 10             	mov    0x10(%ebp),%eax
  80152b:	01 c2                	add    %eax,%edx
  80152d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801530:	8b 45 0c             	mov    0xc(%ebp),%eax
  801533:	01 c8                	add    %ecx,%eax
  801535:	8a 00                	mov    (%eax),%al
  801537:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801539:	ff 45 f8             	incl   -0x8(%ebp)
  80153c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801542:	7c d9                	jl     80151d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801544:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801547:	8b 45 10             	mov    0x10(%ebp),%eax
  80154a:	01 d0                	add    %edx,%eax
  80154c:	c6 00 00             	movb   $0x0,(%eax)
}
  80154f:	90                   	nop
  801550:	c9                   	leave  
  801551:	c3                   	ret    

00801552 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801555:	8b 45 14             	mov    0x14(%ebp),%eax
  801558:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80155e:	8b 45 14             	mov    0x14(%ebp),%eax
  801561:	8b 00                	mov    (%eax),%eax
  801563:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80156a:	8b 45 10             	mov    0x10(%ebp),%eax
  80156d:	01 d0                	add    %edx,%eax
  80156f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801575:	eb 0c                	jmp    801583 <strsplit+0x31>
			*string++ = 0;
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	8d 50 01             	lea    0x1(%eax),%edx
  80157d:	89 55 08             	mov    %edx,0x8(%ebp)
  801580:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	8a 00                	mov    (%eax),%al
  801588:	84 c0                	test   %al,%al
  80158a:	74 18                	je     8015a4 <strsplit+0x52>
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	0f be c0             	movsbl %al,%eax
  801594:	50                   	push   %eax
  801595:	ff 75 0c             	pushl  0xc(%ebp)
  801598:	e8 13 fb ff ff       	call   8010b0 <strchr>
  80159d:	83 c4 08             	add    $0x8,%esp
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	75 d3                	jne    801577 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	8a 00                	mov    (%eax),%al
  8015a9:	84 c0                	test   %al,%al
  8015ab:	74 5a                	je     801607 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8015ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b0:	8b 00                	mov    (%eax),%eax
  8015b2:	83 f8 0f             	cmp    $0xf,%eax
  8015b5:	75 07                	jne    8015be <strsplit+0x6c>
		{
			return 0;
  8015b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bc:	eb 66                	jmp    801624 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8015be:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c1:	8b 00                	mov    (%eax),%eax
  8015c3:	8d 48 01             	lea    0x1(%eax),%ecx
  8015c6:	8b 55 14             	mov    0x14(%ebp),%edx
  8015c9:	89 0a                	mov    %ecx,(%edx)
  8015cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d5:	01 c2                	add    %eax,%edx
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015dc:	eb 03                	jmp    8015e1 <strsplit+0x8f>
			string++;
  8015de:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8a 00                	mov    (%eax),%al
  8015e6:	84 c0                	test   %al,%al
  8015e8:	74 8b                	je     801575 <strsplit+0x23>
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	8a 00                	mov    (%eax),%al
  8015ef:	0f be c0             	movsbl %al,%eax
  8015f2:	50                   	push   %eax
  8015f3:	ff 75 0c             	pushl  0xc(%ebp)
  8015f6:	e8 b5 fa ff ff       	call   8010b0 <strchr>
  8015fb:	83 c4 08             	add    $0x8,%esp
  8015fe:	85 c0                	test   %eax,%eax
  801600:	74 dc                	je     8015de <strsplit+0x8c>
			string++;
	}
  801602:	e9 6e ff ff ff       	jmp    801575 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801607:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801608:	8b 45 14             	mov    0x14(%ebp),%eax
  80160b:	8b 00                	mov    (%eax),%eax
  80160d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801614:	8b 45 10             	mov    0x10(%ebp),%eax
  801617:	01 d0                	add    %edx,%eax
  801619:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80161f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <malloc>:
struct page pages[(USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE];
uint32 be_space,be_address,first_empty_space,index,ad,
emp_space,find,array_size=0;
int nump,si,ind;
void* malloc(uint32 size)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	//BOOL VARIABLE COUNT FREE SPACES IN MEM
	free_mem_count=0;
  80162c:	c7 05 4c 31 80 00 00 	movl   $0x0,0x80314c
  801633:	00 00 00 
	//BOOL VARIABLE check is there suitable space or not
	find=0;
  801636:	c7 05 48 31 80 00 00 	movl   $0x0,0x803148
  80163d:	00 00 00 
	// Initialize user heap memory (1GB = 2^30)->MAX_NUM
	if(intialize_mem==0)
  801640:	a1 28 30 80 00       	mov    0x803028,%eax
  801645:	85 c0                	test   %eax,%eax
  801647:	75 65                	jne    8016ae <malloc+0x88>
	{
		for(j=USER_HEAP_START;j<USER_HEAP_MAX;j+=PAGE_SIZE)
  801649:	c7 05 2c 31 80 00 00 	movl   $0x80000000,0x80312c
  801650:	00 00 80 
  801653:	eb 43                	jmp    801698 <malloc+0x72>
		{
			pages[array_size].address=j; // store start address of each 4k(Page_size)
  801655:	8b 15 2c 30 80 00    	mov    0x80302c,%edx
  80165b:	a1 2c 31 80 00       	mov    0x80312c,%eax
  801660:	c1 e2 04             	shl    $0x4,%edx
  801663:	81 c2 60 31 80 00    	add    $0x803160,%edx
  801669:	89 02                	mov    %eax,(%edx)
			pages[array_size].used=0;//not used
  80166b:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801670:	c1 e0 04             	shl    $0x4,%eax
  801673:	05 64 31 80 00       	add    $0x803164,%eax
  801678:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			array_size+=1;
  80167e:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801683:	40                   	inc    %eax
  801684:	a3 2c 30 80 00       	mov    %eax,0x80302c
	//BOOL VARIABLE check is there suitable space or not
	find=0;
	// Initialize user heap memory (1GB = 2^30)->MAX_NUM
	if(intialize_mem==0)
	{
		for(j=USER_HEAP_START;j<USER_HEAP_MAX;j+=PAGE_SIZE)
  801689:	a1 2c 31 80 00       	mov    0x80312c,%eax
  80168e:	05 00 10 00 00       	add    $0x1000,%eax
  801693:	a3 2c 31 80 00       	mov    %eax,0x80312c
  801698:	a1 2c 31 80 00       	mov    0x80312c,%eax
  80169d:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  8016a2:	76 b1                	jbe    801655 <malloc+0x2f>
		{
			pages[array_size].address=j; // store start address of each 4k(Page_size)
			pages[array_size].used=0;//not used
			array_size+=1;
		}
		intialize_mem=1;
  8016a4:	c7 05 28 30 80 00 01 	movl   $0x1,0x803028
  8016ab:	00 00 00 
	}
	be_space=MAX_NUM;
  8016ae:	c7 05 5c 31 80 00 00 	movl   $0x40000000,0x80315c
  8016b5:	00 00 40 
	//find upper limit of size and calculate num of pages with given size
	round=ROUNDUP(size/1024,4);
  8016b8:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	c1 e8 0a             	shr    $0xa,%eax
  8016c5:	89 c2                	mov    %eax,%edx
  8016c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ca:	01 d0                	add    %edx,%eax
  8016cc:	48                   	dec    %eax
  8016cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d8:	f7 75 f4             	divl   -0xc(%ebp)
  8016db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016de:	29 d0                	sub    %edx,%eax
  8016e0:	a3 28 31 80 00       	mov    %eax,0x803128
	no_of_pages=round/4;
  8016e5:	a1 28 31 80 00       	mov    0x803128,%eax
  8016ea:	c1 e8 02             	shr    $0x2,%eax
  8016ed:	a3 60 31 a0 00       	mov    %eax,0xa03160
	// find empty spaces in user heap mem
	for(j=0;j<array_size;++j)
  8016f2:	c7 05 2c 31 80 00 00 	movl   $0x0,0x80312c
  8016f9:	00 00 00 
  8016fc:	e9 96 00 00 00       	jmp    801797 <malloc+0x171>
	{
		if(pages[j].used==0) //check empty pages
  801701:	a1 2c 31 80 00       	mov    0x80312c,%eax
  801706:	c1 e0 04             	shl    $0x4,%eax
  801709:	05 64 31 80 00       	add    $0x803164,%eax
  80170e:	8b 00                	mov    (%eax),%eax
  801710:	85 c0                	test   %eax,%eax
  801712:	75 2a                	jne    80173e <malloc+0x118>
		{
			//first empty space only
			if(free_mem_count==0)
  801714:	a1 4c 31 80 00       	mov    0x80314c,%eax
  801719:	85 c0                	test   %eax,%eax
  80171b:	75 14                	jne    801731 <malloc+0x10b>
			{
				first_empty_space=pages[j].address;
  80171d:	a1 2c 31 80 00       	mov    0x80312c,%eax
  801722:	c1 e0 04             	shl    $0x4,%eax
  801725:	05 60 31 80 00       	add    $0x803160,%eax
  80172a:	8b 00                	mov    (%eax),%eax
  80172c:	a3 30 31 80 00       	mov    %eax,0x803130
			}
			free_mem_count++; // increment num of free spaces
  801731:	a1 4c 31 80 00       	mov    0x80314c,%eax
  801736:	40                   	inc    %eax
  801737:	a3 4c 31 80 00       	mov    %eax,0x80314c
  80173c:	eb 4e                	jmp    80178c <malloc+0x166>
		}
		else //pages[j].used!=0(==1)used
		{
			// best fit strategy
			emp_space=free_mem_count*PAGE_SIZE;
  80173e:	a1 4c 31 80 00       	mov    0x80314c,%eax
  801743:	c1 e0 0c             	shl    $0xc,%eax
  801746:	a3 34 31 80 00       	mov    %eax,0x803134
			// find min space to fit given size in array
			if(be_space>emp_space&&emp_space>=size)
  80174b:	8b 15 5c 31 80 00    	mov    0x80315c,%edx
  801751:	a1 34 31 80 00       	mov    0x803134,%eax
  801756:	39 c2                	cmp    %eax,%edx
  801758:	76 28                	jbe    801782 <malloc+0x15c>
  80175a:	a1 34 31 80 00       	mov    0x803134,%eax
  80175f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801762:	72 1e                	jb     801782 <malloc+0x15c>
			{
				// reset min value to repeat condition to find suitable space (ms7 mosawi2 aw2kbr b shwi2)
				be_space=emp_space;
  801764:	a1 34 31 80 00       	mov    0x803134,%eax
  801769:	a3 5c 31 80 00       	mov    %eax,0x80315c
				// set start address of empty space
				be_address=first_empty_space;
  80176e:	a1 30 31 80 00       	mov    0x803130,%eax
  801773:	a3 58 31 80 00       	mov    %eax,0x803158
				find=1;
  801778:	c7 05 48 31 80 00 01 	movl   $0x1,0x803148
  80177f:	00 00 00 
			}
			free_mem_count=0;
  801782:	c7 05 4c 31 80 00 00 	movl   $0x0,0x80314c
  801789:	00 00 00 
	be_space=MAX_NUM;
	//find upper limit of size and calculate num of pages with given size
	round=ROUNDUP(size/1024,4);
	no_of_pages=round/4;
	// find empty spaces in user heap mem
	for(j=0;j<array_size;++j)
  80178c:	a1 2c 31 80 00       	mov    0x80312c,%eax
  801791:	40                   	inc    %eax
  801792:	a3 2c 31 80 00       	mov    %eax,0x80312c
  801797:	8b 15 2c 31 80 00    	mov    0x80312c,%edx
  80179d:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8017a2:	39 c2                	cmp    %eax,%edx
  8017a4:	0f 82 57 ff ff ff    	jb     801701 <malloc+0xdb>
			}
			free_mem_count=0;
		}
	}
	// re calc new empty space
	emp_space=free_mem_count*PAGE_SIZE;
  8017aa:	a1 4c 31 80 00       	mov    0x80314c,%eax
  8017af:	c1 e0 0c             	shl    $0xc,%eax
  8017b2:	a3 34 31 80 00       	mov    %eax,0x803134
	// check if this empty space suitable to fit given size or not
	if(be_space>emp_space&&emp_space>=size)
  8017b7:	8b 15 5c 31 80 00    	mov    0x80315c,%edx
  8017bd:	a1 34 31 80 00       	mov    0x803134,%eax
  8017c2:	39 c2                	cmp    %eax,%edx
  8017c4:	76 1e                	jbe    8017e4 <malloc+0x1be>
  8017c6:	a1 34 31 80 00       	mov    0x803134,%eax
  8017cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017ce:	72 14                	jb     8017e4 <malloc+0x1be>
	{
		find=1;
  8017d0:	c7 05 48 31 80 00 01 	movl   $0x1,0x803148
  8017d7:	00 00 00 
		// set final start address of empty space
		be_address=first_empty_space;
  8017da:	a1 30 31 80 00       	mov    0x803130,%eax
  8017df:	a3 58 31 80 00       	mov    %eax,0x803158
	}
	if(find==0) // no suitable space found
  8017e4:	a1 48 31 80 00       	mov    0x803148,%eax
  8017e9:	85 c0                	test   %eax,%eax
  8017eb:	75 0a                	jne    8017f7 <malloc+0x1d1>
	{
		return NULL;
  8017ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f2:	e9 fa 00 00 00       	jmp    8018f1 <malloc+0x2cb>
	}
	for(j=0;j<array_size;++j)
  8017f7:	c7 05 2c 31 80 00 00 	movl   $0x0,0x80312c
  8017fe:	00 00 00 
  801801:	eb 2f                	jmp    801832 <malloc+0x20c>
	{
		if (pages[j].address==be_address)
  801803:	a1 2c 31 80 00       	mov    0x80312c,%eax
  801808:	c1 e0 04             	shl    $0x4,%eax
  80180b:	05 60 31 80 00       	add    $0x803160,%eax
  801810:	8b 10                	mov    (%eax),%edx
  801812:	a1 58 31 80 00       	mov    0x803158,%eax
  801817:	39 c2                	cmp    %eax,%edx
  801819:	75 0c                	jne    801827 <malloc+0x201>
		{
			index=j;
  80181b:	a1 2c 31 80 00       	mov    0x80312c,%eax
  801820:	a3 50 31 80 00       	mov    %eax,0x803150
			break;
  801825:	eb 1a                	jmp    801841 <malloc+0x21b>
	}
	if(find==0) // no suitable space found
	{
		return NULL;
	}
	for(j=0;j<array_size;++j)
  801827:	a1 2c 31 80 00       	mov    0x80312c,%eax
  80182c:	40                   	inc    %eax
  80182d:	a3 2c 31 80 00       	mov    %eax,0x80312c
  801832:	8b 15 2c 31 80 00    	mov    0x80312c,%edx
  801838:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80183d:	39 c2                	cmp    %eax,%edx
  80183f:	72 c2                	jb     801803 <malloc+0x1dd>
			index=j;
			break;
		}
	}
	// set num of pages to address in array
	pages[index].num_of_pages=no_of_pages;
  801841:	8b 15 50 31 80 00    	mov    0x803150,%edx
  801847:	a1 60 31 a0 00       	mov    0xa03160,%eax
  80184c:	c1 e2 04             	shl    $0x4,%edx
  80184f:	81 c2 68 31 80 00    	add    $0x803168,%edx
  801855:	89 02                	mov    %eax,(%edx)
	pages[index].siize=size;
  801857:	a1 50 31 80 00       	mov    0x803150,%eax
  80185c:	c1 e0 04             	shl    $0x4,%eax
  80185f:	8d 90 6c 31 80 00    	lea    0x80316c(%eax),%edx
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	89 02                	mov    %eax,(%edx)
	ind=index;
  80186a:	a1 50 31 80 00       	mov    0x803150,%eax
  80186f:	a3 3c 31 80 00       	mov    %eax,0x80313c

	// loop in n to reset used value to 1 b3add l pages
	for(j=0;j<no_of_pages;++j)
  801874:	c7 05 2c 31 80 00 00 	movl   $0x0,0x80312c
  80187b:	00 00 00 
  80187e:	eb 29                	jmp    8018a9 <malloc+0x283>
	{
		pages[index].used=1;
  801880:	a1 50 31 80 00       	mov    0x803150,%eax
  801885:	c1 e0 04             	shl    $0x4,%eax
  801888:	05 64 31 80 00       	add    $0x803164,%eax
  80188d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		++index;
  801893:	a1 50 31 80 00       	mov    0x803150,%eax
  801898:	40                   	inc    %eax
  801899:	a3 50 31 80 00       	mov    %eax,0x803150
	pages[index].num_of_pages=no_of_pages;
	pages[index].siize=size;
	ind=index;

	// loop in n to reset used value to 1 b3add l pages
	for(j=0;j<no_of_pages;++j)
  80189e:	a1 2c 31 80 00       	mov    0x80312c,%eax
  8018a3:	40                   	inc    %eax
  8018a4:	a3 2c 31 80 00       	mov    %eax,0x80312c
  8018a9:	8b 15 2c 31 80 00    	mov    0x80312c,%edx
  8018af:	a1 60 31 a0 00       	mov    0xa03160,%eax
  8018b4:	39 c2                	cmp    %eax,%edx
  8018b6:	72 c8                	jb     801880 <malloc+0x25a>
	{
		pages[index].used=1;
		++index;
	}
	// Swap from user heap to kernel
	sys_allocateMem(be_address,size);
  8018b8:	a1 58 31 80 00       	mov    0x803158,%eax
  8018bd:	83 ec 08             	sub    $0x8,%esp
  8018c0:	ff 75 08             	pushl  0x8(%ebp)
  8018c3:	50                   	push   %eax
  8018c4:	e8 ea 03 00 00       	call   801cb3 <sys_allocateMem>
  8018c9:	83 c4 10             	add    $0x10,%esp
	ad = be_address;
  8018cc:	a1 58 31 80 00       	mov    0x803158,%eax
  8018d1:	a3 20 31 80 00       	mov    %eax,0x803120
	si = size/2;
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	d1 e8                	shr    %eax
  8018db:	a3 38 31 80 00       	mov    %eax,0x803138
	nump = no_of_pages/2;
  8018e0:	a1 60 31 a0 00       	mov    0xa03160,%eax
  8018e5:	d1 e8                	shr    %eax
  8018e7:	a3 40 31 80 00       	mov    %eax,0x803140
	return (void*)be_address;
  8018ec:	a1 58 31 80 00       	mov    0x803158,%eax
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	return NULL;
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <free>:

uint32 size, maxmam_size,fif;
void free(void* virtual_address)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	83 ec 28             	sub    $0x28,%esp
int index;
	//found index of virtual address
	for(int i=0;i<array_size;i++)
  8018f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801900:	eb 1d                	jmp    80191f <free+0x2c>
	{
		if((void *)pages[i].address == virtual_address)
  801902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801905:	c1 e0 04             	shl    $0x4,%eax
  801908:	05 60 31 80 00       	add    $0x803160,%eax
  80190d:	8b 00                	mov    (%eax),%eax
  80190f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801912:	75 08                	jne    80191c <free+0x29>
		{
			index = i;
  801914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801917:	89 45 f4             	mov    %eax,-0xc(%ebp)
			break;
  80191a:	eb 0f                	jmp    80192b <free+0x38>
uint32 size, maxmam_size,fif;
void free(void* virtual_address)
{
int index;
	//found index of virtual address
	for(int i=0;i<array_size;i++)
  80191c:	ff 45 f0             	incl   -0x10(%ebp)
  80191f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801922:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801927:	39 c2                	cmp    %eax,%edx
  801929:	72 d7                	jb     801902 <free+0xf>
			break;
		}
	}

	//get num of pages
	int num_of_pages = pages[index].num_of_pages;
  80192b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192e:	c1 e0 04             	shl    $0x4,%eax
  801931:	05 68 31 80 00       	add    $0x803168,%eax
  801936:	8b 00                	mov    (%eax),%eax
  801938:	89 45 e8             	mov    %eax,-0x18(%ebp)
	pages[index].num_of_pages=0;
  80193b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193e:	c1 e0 04             	shl    $0x4,%eax
  801941:	05 68 31 80 00       	add    $0x803168,%eax
  801946:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	uint32 va = pages[index].address;
  80194c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194f:	c1 e0 04             	shl    $0x4,%eax
  801952:	05 60 31 80 00       	add    $0x803160,%eax
  801957:	8b 00                	mov    (%eax),%eax
  801959:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//set used to 0
	for(int i=0;i<num_of_pages;i++)
  80195c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801963:	eb 17                	jmp    80197c <free+0x89>
	{
		pages[index].used=0;
  801965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801968:	c1 e0 04             	shl    $0x4,%eax
  80196b:	05 64 31 80 00       	add    $0x803164,%eax
  801970:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		index++;
  801976:	ff 45 f4             	incl   -0xc(%ebp)
	int num_of_pages = pages[index].num_of_pages;
	pages[index].num_of_pages=0;
	uint32 va = pages[index].address;

	//set used to 0
	for(int i=0;i<num_of_pages;i++)
  801979:	ff 45 ec             	incl   -0x14(%ebp)
  80197c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80197f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801982:	7c e1                	jl     801965 <free+0x72>
	{
		pages[index].used=0;
		index++;
	}
	// Swap from user heap to kernel
	sys_freeMem(va, num_of_pages*PAGE_SIZE);
  801984:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801987:	c1 e0 0c             	shl    $0xc,%eax
  80198a:	83 ec 08             	sub    $0x8,%esp
  80198d:	50                   	push   %eax
  80198e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801991:	e8 01 03 00 00       	call   801c97 <sys_freeMem>
  801996:	83 c4 10             	add    $0x10,%esp
}
  801999:	90                   	nop
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 18             	sub    $0x18,%esp
  8019a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a5:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  8019a8:	83 ec 04             	sub    $0x4,%esp
  8019ab:	68 d0 29 80 00       	push   $0x8029d0
  8019b0:	68 a0 00 00 00       	push   $0xa0
  8019b5:	68 f3 29 80 00       	push   $0x8029f3
  8019ba:	e8 7e 07 00 00       	call   80213d <_panic>

008019bf <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019c5:	83 ec 04             	sub    $0x4,%esp
  8019c8:	68 d0 29 80 00       	push   $0x8029d0
  8019cd:	68 a6 00 00 00       	push   $0xa6
  8019d2:	68 f3 29 80 00       	push   $0x8029f3
  8019d7:	e8 61 07 00 00       	call   80213d <_panic>

008019dc <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019e2:	83 ec 04             	sub    $0x4,%esp
  8019e5:	68 d0 29 80 00       	push   $0x8029d0
  8019ea:	68 ac 00 00 00       	push   $0xac
  8019ef:	68 f3 29 80 00       	push   $0x8029f3
  8019f4:	e8 44 07 00 00       	call   80213d <_panic>

008019f9 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019ff:	83 ec 04             	sub    $0x4,%esp
  801a02:	68 d0 29 80 00       	push   $0x8029d0
  801a07:	68 b1 00 00 00       	push   $0xb1
  801a0c:	68 f3 29 80 00       	push   $0x8029f3
  801a11:	e8 27 07 00 00       	call   80213d <_panic>

00801a16 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a1c:	83 ec 04             	sub    $0x4,%esp
  801a1f:	68 d0 29 80 00       	push   $0x8029d0
  801a24:	68 b7 00 00 00       	push   $0xb7
  801a29:	68 f3 29 80 00       	push   $0x8029f3
  801a2e:	e8 0a 07 00 00       	call   80213d <_panic>

00801a33 <shrink>:
}
void shrink(uint32 newSize)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a39:	83 ec 04             	sub    $0x4,%esp
  801a3c:	68 d0 29 80 00       	push   $0x8029d0
  801a41:	68 bb 00 00 00       	push   $0xbb
  801a46:	68 f3 29 80 00       	push   $0x8029f3
  801a4b:	e8 ed 06 00 00       	call   80213d <_panic>

00801a50 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a56:	83 ec 04             	sub    $0x4,%esp
  801a59:	68 d0 29 80 00       	push   $0x8029d0
  801a5e:	68 c0 00 00 00       	push   $0xc0
  801a63:	68 f3 29 80 00       	push   $0x8029f3
  801a68:	e8 d0 06 00 00       	call   80213d <_panic>

00801a6d <halfLast>:
}

void halfLast(){
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	83 ec 18             	sub    $0x18,%esp
	for(i=array_size;i>pa/2;--i)
	{
		pages[va].used=0;
		va+=PAGE_SIZE;
	}*/
	uint32 halfAdd = ad+si;
  801a73:	a1 20 31 80 00       	mov    0x803120,%eax
  801a78:	8b 15 38 31 80 00    	mov    0x803138,%edx
  801a7e:	01 d0                	add    %edx,%eax
  801a80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	ind+=nump;
  801a83:	8b 15 3c 31 80 00    	mov    0x80313c,%edx
  801a89:	a1 40 31 80 00       	mov    0x803140,%eax
  801a8e:	01 d0                	add    %edx,%eax
  801a90:	a3 3c 31 80 00       	mov    %eax,0x80313c
	for(int i=0;i<nump;i++){
  801a95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801a9c:	eb 21                	jmp    801abf <halfLast+0x52>
		pages[ind].used=0;
  801a9e:	a1 3c 31 80 00       	mov    0x80313c,%eax
  801aa3:	c1 e0 04             	shl    $0x4,%eax
  801aa6:	05 64 31 80 00       	add    $0x803164,%eax
  801aab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		ind++;
  801ab1:	a1 3c 31 80 00       	mov    0x80313c,%eax
  801ab6:	40                   	inc    %eax
  801ab7:	a3 3c 31 80 00       	mov    %eax,0x80313c
		pages[va].used=0;
		va+=PAGE_SIZE;
	}*/
	uint32 halfAdd = ad+si;
	ind+=nump;
	for(int i=0;i<nump;i++){
  801abc:	ff 45 f4             	incl   -0xc(%ebp)
  801abf:	a1 40 31 80 00       	mov    0x803140,%eax
  801ac4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801ac7:	7c d5                	jl     801a9e <halfLast+0x31>
		pages[ind].used=0;
		ind++;
	}
	sys_freeMem(halfAdd,si);
  801ac9:	a1 38 31 80 00       	mov    0x803138,%eax
  801ace:	83 ec 08             	sub    $0x8,%esp
  801ad1:	50                   	push   %eax
  801ad2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ad5:	e8 bd 01 00 00       	call   801c97 <sys_freeMem>
  801ada:	83 c4 10             	add    $0x10,%esp
	//free((void*)ad);
	//malloc(nup);
}
  801add:	90                   	nop
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	57                   	push   %edi
  801ae4:	56                   	push   %esi
  801ae5:	53                   	push   %ebx
  801ae6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801af2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801af5:	8b 7d 18             	mov    0x18(%ebp),%edi
  801af8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801afb:	cd 30                	int    $0x30
  801afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b03:	83 c4 10             	add    $0x10,%esp
  801b06:	5b                   	pop    %ebx
  801b07:	5e                   	pop    %esi
  801b08:	5f                   	pop    %edi
  801b09:	5d                   	pop    %ebp
  801b0a:	c3                   	ret    

00801b0b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	83 ec 04             	sub    $0x4,%esp
  801b11:	8b 45 10             	mov    0x10(%ebp),%eax
  801b14:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b17:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	52                   	push   %edx
  801b23:	ff 75 0c             	pushl  0xc(%ebp)
  801b26:	50                   	push   %eax
  801b27:	6a 00                	push   $0x0
  801b29:	e8 b2 ff ff ff       	call   801ae0 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	90                   	nop
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 01                	push   $0x1
  801b43:	e8 98 ff ff ff       	call   801ae0 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	50                   	push   %eax
  801b5c:	6a 05                	push   $0x5
  801b5e:	e8 7d ff ff ff       	call   801ae0 <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 02                	push   $0x2
  801b77:	e8 64 ff ff ff       	call   801ae0 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 03                	push   $0x3
  801b90:	e8 4b ff ff ff       	call   801ae0 <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 04                	push   $0x4
  801ba9:	e8 32 ff ff ff       	call   801ae0 <syscall>
  801bae:	83 c4 18             	add    $0x18,%esp
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <sys_env_exit>:


void sys_env_exit(void)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 06                	push   $0x6
  801bc2:	e8 19 ff ff ff       	call   801ae0 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	90                   	nop
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801bd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	52                   	push   %edx
  801bdd:	50                   	push   %eax
  801bde:	6a 07                	push   $0x7
  801be0:	e8 fb fe ff ff       	call   801ae0 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	56                   	push   %esi
  801bee:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bef:	8b 75 18             	mov    0x18(%ebp),%esi
  801bf2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bf5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bf8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	56                   	push   %esi
  801bff:	53                   	push   %ebx
  801c00:	51                   	push   %ecx
  801c01:	52                   	push   %edx
  801c02:	50                   	push   %eax
  801c03:	6a 08                	push   $0x8
  801c05:	e8 d6 fe ff ff       	call   801ae0 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
}
  801c0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c10:	5b                   	pop    %ebx
  801c11:	5e                   	pop    %esi
  801c12:	5d                   	pop    %ebp
  801c13:	c3                   	ret    

00801c14 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	52                   	push   %edx
  801c24:	50                   	push   %eax
  801c25:	6a 09                	push   $0x9
  801c27:	e8 b4 fe ff ff       	call   801ae0 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	ff 75 0c             	pushl  0xc(%ebp)
  801c3d:	ff 75 08             	pushl  0x8(%ebp)
  801c40:	6a 0a                	push   $0xa
  801c42:	e8 99 fe ff ff       	call   801ae0 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 0b                	push   $0xb
  801c5b:	e8 80 fe ff ff       	call   801ae0 <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 0c                	push   $0xc
  801c74:	e8 67 fe ff ff       	call   801ae0 <syscall>
  801c79:	83 c4 18             	add    $0x18,%esp
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 0d                	push   $0xd
  801c8d:	e8 4e fe ff ff       	call   801ae0 <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	ff 75 0c             	pushl  0xc(%ebp)
  801ca3:	ff 75 08             	pushl  0x8(%ebp)
  801ca6:	6a 11                	push   $0x11
  801ca8:	e8 33 fe ff ff       	call   801ae0 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
	return;
  801cb0:	90                   	nop
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	ff 75 0c             	pushl  0xc(%ebp)
  801cbf:	ff 75 08             	pushl  0x8(%ebp)
  801cc2:	6a 12                	push   $0x12
  801cc4:	e8 17 fe ff ff       	call   801ae0 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ccc:	90                   	nop
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 0e                	push   $0xe
  801cde:	e8 fd fd ff ff       	call   801ae0 <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	ff 75 08             	pushl  0x8(%ebp)
  801cf6:	6a 0f                	push   $0xf
  801cf8:	e8 e3 fd ff ff       	call   801ae0 <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 10                	push   $0x10
  801d11:	e8 ca fd ff ff       	call   801ae0 <syscall>
  801d16:	83 c4 18             	add    $0x18,%esp
}
  801d19:	90                   	nop
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 14                	push   $0x14
  801d2b:	e8 b0 fd ff ff       	call   801ae0 <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
}
  801d33:	90                   	nop
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 15                	push   $0x15
  801d45:	e8 96 fd ff ff       	call   801ae0 <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
}
  801d4d:	90                   	nop
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	83 ec 04             	sub    $0x4,%esp
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d5c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	50                   	push   %eax
  801d69:	6a 16                	push   $0x16
  801d6b:	e8 70 fd ff ff       	call   801ae0 <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
}
  801d73:	90                   	nop
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 17                	push   $0x17
  801d85:	e8 56 fd ff ff       	call   801ae0 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
}
  801d8d:	90                   	nop
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	ff 75 0c             	pushl  0xc(%ebp)
  801d9f:	50                   	push   %eax
  801da0:	6a 18                	push   $0x18
  801da2:	e8 39 fd ff ff       	call   801ae0 <syscall>
  801da7:	83 c4 18             	add    $0x18,%esp
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801daf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	52                   	push   %edx
  801dbc:	50                   	push   %eax
  801dbd:	6a 1b                	push   $0x1b
  801dbf:	e8 1c fd ff ff       	call   801ae0 <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	52                   	push   %edx
  801dd9:	50                   	push   %eax
  801dda:	6a 19                	push   $0x19
  801ddc:	e8 ff fc ff ff       	call   801ae0 <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
}
  801de4:	90                   	nop
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	52                   	push   %edx
  801df7:	50                   	push   %eax
  801df8:	6a 1a                	push   $0x1a
  801dfa:	e8 e1 fc ff ff       	call   801ae0 <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
}
  801e02:	90                   	nop
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	83 ec 04             	sub    $0x4,%esp
  801e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e11:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e14:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e18:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1b:	6a 00                	push   $0x0
  801e1d:	51                   	push   %ecx
  801e1e:	52                   	push   %edx
  801e1f:	ff 75 0c             	pushl  0xc(%ebp)
  801e22:	50                   	push   %eax
  801e23:	6a 1c                	push   $0x1c
  801e25:	e8 b6 fc ff ff       	call   801ae0 <syscall>
  801e2a:	83 c4 18             	add    $0x18,%esp
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	52                   	push   %edx
  801e3f:	50                   	push   %eax
  801e40:	6a 1d                	push   $0x1d
  801e42:	e8 99 fc ff ff       	call   801ae0 <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	51                   	push   %ecx
  801e5d:	52                   	push   %edx
  801e5e:	50                   	push   %eax
  801e5f:	6a 1e                	push   $0x1e
  801e61:	e8 7a fc ff ff       	call   801ae0 <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	52                   	push   %edx
  801e7b:	50                   	push   %eax
  801e7c:	6a 1f                	push   $0x1f
  801e7e:	e8 5d fc ff ff       	call   801ae0 <syscall>
  801e83:	83 c4 18             	add    $0x18,%esp
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 20                	push   $0x20
  801e97:	e8 44 fc ff ff       	call   801ae0 <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea7:	6a 00                	push   $0x0
  801ea9:	ff 75 14             	pushl  0x14(%ebp)
  801eac:	ff 75 10             	pushl  0x10(%ebp)
  801eaf:	ff 75 0c             	pushl  0xc(%ebp)
  801eb2:	50                   	push   %eax
  801eb3:	6a 21                	push   $0x21
  801eb5:	e8 26 fc ff ff       	call   801ae0 <syscall>
  801eba:	83 c4 18             	add    $0x18,%esp
}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	50                   	push   %eax
  801ece:	6a 22                	push   $0x22
  801ed0:	e8 0b fc ff ff       	call   801ae0 <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
}
  801ed8:	90                   	nop
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	50                   	push   %eax
  801eea:	6a 23                	push   $0x23
  801eec:	e8 ef fb ff ff       	call   801ae0 <syscall>
  801ef1:	83 c4 18             	add    $0x18,%esp
}
  801ef4:	90                   	nop
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801efd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f00:	8d 50 04             	lea    0x4(%eax),%edx
  801f03:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	52                   	push   %edx
  801f0d:	50                   	push   %eax
  801f0e:	6a 24                	push   $0x24
  801f10:	e8 cb fb ff ff       	call   801ae0 <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
	return result;
  801f18:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f21:	89 01                	mov    %eax,(%ecx)
  801f23:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	c9                   	leave  
  801f2a:	c2 04 00             	ret    $0x4

00801f2d <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	ff 75 10             	pushl  0x10(%ebp)
  801f37:	ff 75 0c             	pushl  0xc(%ebp)
  801f3a:	ff 75 08             	pushl  0x8(%ebp)
  801f3d:	6a 13                	push   $0x13
  801f3f:	e8 9c fb ff ff       	call   801ae0 <syscall>
  801f44:	83 c4 18             	add    $0x18,%esp
	return ;
  801f47:	90                   	nop
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <sys_rcr2>:
uint32 sys_rcr2()
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 25                	push   $0x25
  801f59:	e8 82 fb ff ff       	call   801ae0 <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	83 ec 04             	sub    $0x4,%esp
  801f69:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f6f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	50                   	push   %eax
  801f7c:	6a 26                	push   $0x26
  801f7e:	e8 5d fb ff ff       	call   801ae0 <syscall>
  801f83:	83 c4 18             	add    $0x18,%esp
	return ;
  801f86:	90                   	nop
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <rsttst>:
void rsttst()
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 28                	push   $0x28
  801f98:	e8 43 fb ff ff       	call   801ae0 <syscall>
  801f9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa0:	90                   	nop
}
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	83 ec 04             	sub    $0x4,%esp
  801fa9:	8b 45 14             	mov    0x14(%ebp),%eax
  801fac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801faf:	8b 55 18             	mov    0x18(%ebp),%edx
  801fb2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fb6:	52                   	push   %edx
  801fb7:	50                   	push   %eax
  801fb8:	ff 75 10             	pushl  0x10(%ebp)
  801fbb:	ff 75 0c             	pushl  0xc(%ebp)
  801fbe:	ff 75 08             	pushl  0x8(%ebp)
  801fc1:	6a 27                	push   $0x27
  801fc3:	e8 18 fb ff ff       	call   801ae0 <syscall>
  801fc8:	83 c4 18             	add    $0x18,%esp
	return ;
  801fcb:	90                   	nop
}
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <chktst>:
void chktst(uint32 n)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	ff 75 08             	pushl  0x8(%ebp)
  801fdc:	6a 29                	push   $0x29
  801fde:	e8 fd fa ff ff       	call   801ae0 <syscall>
  801fe3:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe6:	90                   	nop
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <inctst>:

void inctst()
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 2a                	push   $0x2a
  801ff8:	e8 e3 fa ff ff       	call   801ae0 <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
	return ;
  802000:	90                   	nop
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <gettst>:
uint32 gettst()
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 2b                	push   $0x2b
  802012:	e8 c9 fa ff ff       	call   801ae0 <syscall>
  802017:	83 c4 18             	add    $0x18,%esp
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 2c                	push   $0x2c
  80202e:	e8 ad fa ff ff       	call   801ae0 <syscall>
  802033:	83 c4 18             	add    $0x18,%esp
  802036:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802039:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80203d:	75 07                	jne    802046 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80203f:	b8 01 00 00 00       	mov    $0x1,%eax
  802044:	eb 05                	jmp    80204b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802046:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 2c                	push   $0x2c
  80205f:	e8 7c fa ff ff       	call   801ae0 <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
  802067:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80206a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80206e:	75 07                	jne    802077 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802070:	b8 01 00 00 00       	mov    $0x1,%eax
  802075:	eb 05                	jmp    80207c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802077:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 2c                	push   $0x2c
  802090:	e8 4b fa ff ff       	call   801ae0 <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
  802098:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80209b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80209f:	75 07                	jne    8020a8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a6:	eb 05                	jmp    8020ad <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 2c                	push   $0x2c
  8020c1:	e8 1a fa ff ff       	call   801ae0 <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
  8020c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020cc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020d0:	75 07                	jne    8020d9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d7:	eb 05                	jmp    8020de <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	ff 75 08             	pushl  0x8(%ebp)
  8020ee:	6a 2d                	push   $0x2d
  8020f0:	e8 eb f9 ff ff       	call   801ae0 <syscall>
  8020f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f8:	90                   	nop
}
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802102:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802105:	8b 55 0c             	mov    0xc(%ebp),%edx
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	6a 00                	push   $0x0
  80210d:	53                   	push   %ebx
  80210e:	51                   	push   %ecx
  80210f:	52                   	push   %edx
  802110:	50                   	push   %eax
  802111:	6a 2e                	push   $0x2e
  802113:	e8 c8 f9 ff ff       	call   801ae0 <syscall>
  802118:	83 c4 18             	add    $0x18,%esp
}
  80211b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802123:	8b 55 0c             	mov    0xc(%ebp),%edx
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	52                   	push   %edx
  802130:	50                   	push   %eax
  802131:	6a 2f                	push   $0x2f
  802133:	e8 a8 f9 ff ff       	call   801ae0 <syscall>
  802138:	83 c4 18             	add    $0x18,%esp
}
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
  802140:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802143:	8d 45 10             	lea    0x10(%ebp),%eax
  802146:	83 c0 04             	add    $0x4,%eax
  802149:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80214c:	a1 64 31 a0 00       	mov    0xa03164,%eax
  802151:	85 c0                	test   %eax,%eax
  802153:	74 16                	je     80216b <_panic+0x2e>
		cprintf("%s: ", argv0);
  802155:	a1 64 31 a0 00       	mov    0xa03164,%eax
  80215a:	83 ec 08             	sub    $0x8,%esp
  80215d:	50                   	push   %eax
  80215e:	68 00 2a 80 00       	push   $0x802a00
  802163:	e8 34 e7 ff ff       	call   80089c <cprintf>
  802168:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80216b:	a1 00 30 80 00       	mov    0x803000,%eax
  802170:	ff 75 0c             	pushl  0xc(%ebp)
  802173:	ff 75 08             	pushl  0x8(%ebp)
  802176:	50                   	push   %eax
  802177:	68 05 2a 80 00       	push   $0x802a05
  80217c:	e8 1b e7 ff ff       	call   80089c <cprintf>
  802181:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802184:	8b 45 10             	mov    0x10(%ebp),%eax
  802187:	83 ec 08             	sub    $0x8,%esp
  80218a:	ff 75 f4             	pushl  -0xc(%ebp)
  80218d:	50                   	push   %eax
  80218e:	e8 9e e6 ff ff       	call   800831 <vcprintf>
  802193:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802196:	83 ec 08             	sub    $0x8,%esp
  802199:	6a 00                	push   $0x0
  80219b:	68 21 2a 80 00       	push   $0x802a21
  8021a0:	e8 8c e6 ff ff       	call   800831 <vcprintf>
  8021a5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8021a8:	e8 0d e6 ff ff       	call   8007ba <exit>

	// should not return here
	while (1) ;
  8021ad:	eb fe                	jmp    8021ad <_panic+0x70>

008021af <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8021b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8021ba:	8b 50 74             	mov    0x74(%eax),%edx
  8021bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c0:	39 c2                	cmp    %eax,%edx
  8021c2:	74 14                	je     8021d8 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8021c4:	83 ec 04             	sub    $0x4,%esp
  8021c7:	68 24 2a 80 00       	push   $0x802a24
  8021cc:	6a 26                	push   $0x26
  8021ce:	68 70 2a 80 00       	push   $0x802a70
  8021d3:	e8 65 ff ff ff       	call   80213d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8021d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8021df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8021e6:	e9 b6 00 00 00       	jmp    8022a1 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8021eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	01 d0                	add    %edx,%eax
  8021fa:	8b 00                	mov    (%eax),%eax
  8021fc:	85 c0                	test   %eax,%eax
  8021fe:	75 08                	jne    802208 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802200:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802203:	e9 96 00 00 00       	jmp    80229e <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  802208:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80220f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802216:	eb 5d                	jmp    802275 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802218:	a1 20 30 80 00       	mov    0x803020,%eax
  80221d:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802223:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802226:	c1 e2 04             	shl    $0x4,%edx
  802229:	01 d0                	add    %edx,%eax
  80222b:	8a 40 04             	mov    0x4(%eax),%al
  80222e:	84 c0                	test   %al,%al
  802230:	75 40                	jne    802272 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802232:	a1 20 30 80 00       	mov    0x803020,%eax
  802237:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80223d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802240:	c1 e2 04             	shl    $0x4,%edx
  802243:	01 d0                	add    %edx,%eax
  802245:	8b 00                	mov    (%eax),%eax
  802247:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80224a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80224d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802252:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802257:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	01 c8                	add    %ecx,%eax
  802263:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802265:	39 c2                	cmp    %eax,%edx
  802267:	75 09                	jne    802272 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  802269:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802270:	eb 12                	jmp    802284 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802272:	ff 45 e8             	incl   -0x18(%ebp)
  802275:	a1 20 30 80 00       	mov    0x803020,%eax
  80227a:	8b 50 74             	mov    0x74(%eax),%edx
  80227d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802280:	39 c2                	cmp    %eax,%edx
  802282:	77 94                	ja     802218 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802284:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802288:	75 14                	jne    80229e <CheckWSWithoutLastIndex+0xef>
			panic(
  80228a:	83 ec 04             	sub    $0x4,%esp
  80228d:	68 7c 2a 80 00       	push   $0x802a7c
  802292:	6a 3a                	push   $0x3a
  802294:	68 70 2a 80 00       	push   $0x802a70
  802299:	e8 9f fe ff ff       	call   80213d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80229e:	ff 45 f0             	incl   -0x10(%ebp)
  8022a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022a7:	0f 8c 3e ff ff ff    	jl     8021eb <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8022ad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8022b4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8022bb:	eb 20                	jmp    8022dd <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8022bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8022c2:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8022c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022cb:	c1 e2 04             	shl    $0x4,%edx
  8022ce:	01 d0                	add    %edx,%eax
  8022d0:	8a 40 04             	mov    0x4(%eax),%al
  8022d3:	3c 01                	cmp    $0x1,%al
  8022d5:	75 03                	jne    8022da <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8022d7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8022da:	ff 45 e0             	incl   -0x20(%ebp)
  8022dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8022e2:	8b 50 74             	mov    0x74(%eax),%edx
  8022e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022e8:	39 c2                	cmp    %eax,%edx
  8022ea:	77 d1                	ja     8022bd <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8022f2:	74 14                	je     802308 <CheckWSWithoutLastIndex+0x159>
		panic(
  8022f4:	83 ec 04             	sub    $0x4,%esp
  8022f7:	68 d0 2a 80 00       	push   $0x802ad0
  8022fc:	6a 44                	push   $0x44
  8022fe:	68 70 2a 80 00       	push   $0x802a70
  802303:	e8 35 fe ff ff       	call   80213d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802308:	90                   	nop
  802309:	c9                   	leave  
  80230a:	c3                   	ret    
  80230b:	90                   	nop

0080230c <__udivdi3>:
  80230c:	55                   	push   %ebp
  80230d:	57                   	push   %edi
  80230e:	56                   	push   %esi
  80230f:	53                   	push   %ebx
  802310:	83 ec 1c             	sub    $0x1c,%esp
  802313:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802317:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80231b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80231f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802323:	89 ca                	mov    %ecx,%edx
  802325:	89 f8                	mov    %edi,%eax
  802327:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80232b:	85 f6                	test   %esi,%esi
  80232d:	75 2d                	jne    80235c <__udivdi3+0x50>
  80232f:	39 cf                	cmp    %ecx,%edi
  802331:	77 65                	ja     802398 <__udivdi3+0x8c>
  802333:	89 fd                	mov    %edi,%ebp
  802335:	85 ff                	test   %edi,%edi
  802337:	75 0b                	jne    802344 <__udivdi3+0x38>
  802339:	b8 01 00 00 00       	mov    $0x1,%eax
  80233e:	31 d2                	xor    %edx,%edx
  802340:	f7 f7                	div    %edi
  802342:	89 c5                	mov    %eax,%ebp
  802344:	31 d2                	xor    %edx,%edx
  802346:	89 c8                	mov    %ecx,%eax
  802348:	f7 f5                	div    %ebp
  80234a:	89 c1                	mov    %eax,%ecx
  80234c:	89 d8                	mov    %ebx,%eax
  80234e:	f7 f5                	div    %ebp
  802350:	89 cf                	mov    %ecx,%edi
  802352:	89 fa                	mov    %edi,%edx
  802354:	83 c4 1c             	add    $0x1c,%esp
  802357:	5b                   	pop    %ebx
  802358:	5e                   	pop    %esi
  802359:	5f                   	pop    %edi
  80235a:	5d                   	pop    %ebp
  80235b:	c3                   	ret    
  80235c:	39 ce                	cmp    %ecx,%esi
  80235e:	77 28                	ja     802388 <__udivdi3+0x7c>
  802360:	0f bd fe             	bsr    %esi,%edi
  802363:	83 f7 1f             	xor    $0x1f,%edi
  802366:	75 40                	jne    8023a8 <__udivdi3+0x9c>
  802368:	39 ce                	cmp    %ecx,%esi
  80236a:	72 0a                	jb     802376 <__udivdi3+0x6a>
  80236c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802370:	0f 87 9e 00 00 00    	ja     802414 <__udivdi3+0x108>
  802376:	b8 01 00 00 00       	mov    $0x1,%eax
  80237b:	89 fa                	mov    %edi,%edx
  80237d:	83 c4 1c             	add    $0x1c,%esp
  802380:	5b                   	pop    %ebx
  802381:	5e                   	pop    %esi
  802382:	5f                   	pop    %edi
  802383:	5d                   	pop    %ebp
  802384:	c3                   	ret    
  802385:	8d 76 00             	lea    0x0(%esi),%esi
  802388:	31 ff                	xor    %edi,%edi
  80238a:	31 c0                	xor    %eax,%eax
  80238c:	89 fa                	mov    %edi,%edx
  80238e:	83 c4 1c             	add    $0x1c,%esp
  802391:	5b                   	pop    %ebx
  802392:	5e                   	pop    %esi
  802393:	5f                   	pop    %edi
  802394:	5d                   	pop    %ebp
  802395:	c3                   	ret    
  802396:	66 90                	xchg   %ax,%ax
  802398:	89 d8                	mov    %ebx,%eax
  80239a:	f7 f7                	div    %edi
  80239c:	31 ff                	xor    %edi,%edi
  80239e:	89 fa                	mov    %edi,%edx
  8023a0:	83 c4 1c             	add    $0x1c,%esp
  8023a3:	5b                   	pop    %ebx
  8023a4:	5e                   	pop    %esi
  8023a5:	5f                   	pop    %edi
  8023a6:	5d                   	pop    %ebp
  8023a7:	c3                   	ret    
  8023a8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8023ad:	89 eb                	mov    %ebp,%ebx
  8023af:	29 fb                	sub    %edi,%ebx
  8023b1:	89 f9                	mov    %edi,%ecx
  8023b3:	d3 e6                	shl    %cl,%esi
  8023b5:	89 c5                	mov    %eax,%ebp
  8023b7:	88 d9                	mov    %bl,%cl
  8023b9:	d3 ed                	shr    %cl,%ebp
  8023bb:	89 e9                	mov    %ebp,%ecx
  8023bd:	09 f1                	or     %esi,%ecx
  8023bf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8023c3:	89 f9                	mov    %edi,%ecx
  8023c5:	d3 e0                	shl    %cl,%eax
  8023c7:	89 c5                	mov    %eax,%ebp
  8023c9:	89 d6                	mov    %edx,%esi
  8023cb:	88 d9                	mov    %bl,%cl
  8023cd:	d3 ee                	shr    %cl,%esi
  8023cf:	89 f9                	mov    %edi,%ecx
  8023d1:	d3 e2                	shl    %cl,%edx
  8023d3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023d7:	88 d9                	mov    %bl,%cl
  8023d9:	d3 e8                	shr    %cl,%eax
  8023db:	09 c2                	or     %eax,%edx
  8023dd:	89 d0                	mov    %edx,%eax
  8023df:	89 f2                	mov    %esi,%edx
  8023e1:	f7 74 24 0c          	divl   0xc(%esp)
  8023e5:	89 d6                	mov    %edx,%esi
  8023e7:	89 c3                	mov    %eax,%ebx
  8023e9:	f7 e5                	mul    %ebp
  8023eb:	39 d6                	cmp    %edx,%esi
  8023ed:	72 19                	jb     802408 <__udivdi3+0xfc>
  8023ef:	74 0b                	je     8023fc <__udivdi3+0xf0>
  8023f1:	89 d8                	mov    %ebx,%eax
  8023f3:	31 ff                	xor    %edi,%edi
  8023f5:	e9 58 ff ff ff       	jmp    802352 <__udivdi3+0x46>
  8023fa:	66 90                	xchg   %ax,%ax
  8023fc:	8b 54 24 08          	mov    0x8(%esp),%edx
  802400:	89 f9                	mov    %edi,%ecx
  802402:	d3 e2                	shl    %cl,%edx
  802404:	39 c2                	cmp    %eax,%edx
  802406:	73 e9                	jae    8023f1 <__udivdi3+0xe5>
  802408:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80240b:	31 ff                	xor    %edi,%edi
  80240d:	e9 40 ff ff ff       	jmp    802352 <__udivdi3+0x46>
  802412:	66 90                	xchg   %ax,%ax
  802414:	31 c0                	xor    %eax,%eax
  802416:	e9 37 ff ff ff       	jmp    802352 <__udivdi3+0x46>
  80241b:	90                   	nop

0080241c <__umoddi3>:
  80241c:	55                   	push   %ebp
  80241d:	57                   	push   %edi
  80241e:	56                   	push   %esi
  80241f:	53                   	push   %ebx
  802420:	83 ec 1c             	sub    $0x1c,%esp
  802423:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802427:	8b 74 24 34          	mov    0x34(%esp),%esi
  80242b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80242f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802433:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802437:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80243b:	89 f3                	mov    %esi,%ebx
  80243d:	89 fa                	mov    %edi,%edx
  80243f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802443:	89 34 24             	mov    %esi,(%esp)
  802446:	85 c0                	test   %eax,%eax
  802448:	75 1a                	jne    802464 <__umoddi3+0x48>
  80244a:	39 f7                	cmp    %esi,%edi
  80244c:	0f 86 a2 00 00 00    	jbe    8024f4 <__umoddi3+0xd8>
  802452:	89 c8                	mov    %ecx,%eax
  802454:	89 f2                	mov    %esi,%edx
  802456:	f7 f7                	div    %edi
  802458:	89 d0                	mov    %edx,%eax
  80245a:	31 d2                	xor    %edx,%edx
  80245c:	83 c4 1c             	add    $0x1c,%esp
  80245f:	5b                   	pop    %ebx
  802460:	5e                   	pop    %esi
  802461:	5f                   	pop    %edi
  802462:	5d                   	pop    %ebp
  802463:	c3                   	ret    
  802464:	39 f0                	cmp    %esi,%eax
  802466:	0f 87 ac 00 00 00    	ja     802518 <__umoddi3+0xfc>
  80246c:	0f bd e8             	bsr    %eax,%ebp
  80246f:	83 f5 1f             	xor    $0x1f,%ebp
  802472:	0f 84 ac 00 00 00    	je     802524 <__umoddi3+0x108>
  802478:	bf 20 00 00 00       	mov    $0x20,%edi
  80247d:	29 ef                	sub    %ebp,%edi
  80247f:	89 fe                	mov    %edi,%esi
  802481:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802485:	89 e9                	mov    %ebp,%ecx
  802487:	d3 e0                	shl    %cl,%eax
  802489:	89 d7                	mov    %edx,%edi
  80248b:	89 f1                	mov    %esi,%ecx
  80248d:	d3 ef                	shr    %cl,%edi
  80248f:	09 c7                	or     %eax,%edi
  802491:	89 e9                	mov    %ebp,%ecx
  802493:	d3 e2                	shl    %cl,%edx
  802495:	89 14 24             	mov    %edx,(%esp)
  802498:	89 d8                	mov    %ebx,%eax
  80249a:	d3 e0                	shl    %cl,%eax
  80249c:	89 c2                	mov    %eax,%edx
  80249e:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024a2:	d3 e0                	shl    %cl,%eax
  8024a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024ac:	89 f1                	mov    %esi,%ecx
  8024ae:	d3 e8                	shr    %cl,%eax
  8024b0:	09 d0                	or     %edx,%eax
  8024b2:	d3 eb                	shr    %cl,%ebx
  8024b4:	89 da                	mov    %ebx,%edx
  8024b6:	f7 f7                	div    %edi
  8024b8:	89 d3                	mov    %edx,%ebx
  8024ba:	f7 24 24             	mull   (%esp)
  8024bd:	89 c6                	mov    %eax,%esi
  8024bf:	89 d1                	mov    %edx,%ecx
  8024c1:	39 d3                	cmp    %edx,%ebx
  8024c3:	0f 82 87 00 00 00    	jb     802550 <__umoddi3+0x134>
  8024c9:	0f 84 91 00 00 00    	je     802560 <__umoddi3+0x144>
  8024cf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024d3:	29 f2                	sub    %esi,%edx
  8024d5:	19 cb                	sbb    %ecx,%ebx
  8024d7:	89 d8                	mov    %ebx,%eax
  8024d9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8024dd:	d3 e0                	shl    %cl,%eax
  8024df:	89 e9                	mov    %ebp,%ecx
  8024e1:	d3 ea                	shr    %cl,%edx
  8024e3:	09 d0                	or     %edx,%eax
  8024e5:	89 e9                	mov    %ebp,%ecx
  8024e7:	d3 eb                	shr    %cl,%ebx
  8024e9:	89 da                	mov    %ebx,%edx
  8024eb:	83 c4 1c             	add    $0x1c,%esp
  8024ee:	5b                   	pop    %ebx
  8024ef:	5e                   	pop    %esi
  8024f0:	5f                   	pop    %edi
  8024f1:	5d                   	pop    %ebp
  8024f2:	c3                   	ret    
  8024f3:	90                   	nop
  8024f4:	89 fd                	mov    %edi,%ebp
  8024f6:	85 ff                	test   %edi,%edi
  8024f8:	75 0b                	jne    802505 <__umoddi3+0xe9>
  8024fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ff:	31 d2                	xor    %edx,%edx
  802501:	f7 f7                	div    %edi
  802503:	89 c5                	mov    %eax,%ebp
  802505:	89 f0                	mov    %esi,%eax
  802507:	31 d2                	xor    %edx,%edx
  802509:	f7 f5                	div    %ebp
  80250b:	89 c8                	mov    %ecx,%eax
  80250d:	f7 f5                	div    %ebp
  80250f:	89 d0                	mov    %edx,%eax
  802511:	e9 44 ff ff ff       	jmp    80245a <__umoddi3+0x3e>
  802516:	66 90                	xchg   %ax,%ax
  802518:	89 c8                	mov    %ecx,%eax
  80251a:	89 f2                	mov    %esi,%edx
  80251c:	83 c4 1c             	add    $0x1c,%esp
  80251f:	5b                   	pop    %ebx
  802520:	5e                   	pop    %esi
  802521:	5f                   	pop    %edi
  802522:	5d                   	pop    %ebp
  802523:	c3                   	ret    
  802524:	3b 04 24             	cmp    (%esp),%eax
  802527:	72 06                	jb     80252f <__umoddi3+0x113>
  802529:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80252d:	77 0f                	ja     80253e <__umoddi3+0x122>
  80252f:	89 f2                	mov    %esi,%edx
  802531:	29 f9                	sub    %edi,%ecx
  802533:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802537:	89 14 24             	mov    %edx,(%esp)
  80253a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80253e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802542:	8b 14 24             	mov    (%esp),%edx
  802545:	83 c4 1c             	add    $0x1c,%esp
  802548:	5b                   	pop    %ebx
  802549:	5e                   	pop    %esi
  80254a:	5f                   	pop    %edi
  80254b:	5d                   	pop    %ebp
  80254c:	c3                   	ret    
  80254d:	8d 76 00             	lea    0x0(%esi),%esi
  802550:	2b 04 24             	sub    (%esp),%eax
  802553:	19 fa                	sbb    %edi,%edx
  802555:	89 d1                	mov    %edx,%ecx
  802557:	89 c6                	mov    %eax,%esi
  802559:	e9 71 ff ff ff       	jmp    8024cf <__umoddi3+0xb3>
  80255e:	66 90                	xchg   %ax,%ax
  802560:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802564:	72 ea                	jb     802550 <__umoddi3+0x134>
  802566:	89 d9                	mov    %ebx,%ecx
  802568:	e9 62 ff ff ff       	jmp    8024cf <__umoddi3+0xb3>
