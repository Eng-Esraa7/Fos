
obj/user/tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 b1 03 00 00       	call   8003e7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 23                	jmp    80006f <_main+0x37>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 30 80 00       	mov    0x803020,%eax
  800051:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	c1 e2 04             	shl    $0x4,%edx
  80005d:	01 d0                	add    %edx,%eax
  80005f:	8a 40 04             	mov    0x4(%eax),%al
  800062:	84 c0                	test   %al,%al
  800064:	74 06                	je     80006c <_main+0x34>
			{
				fullWS = 0;
  800066:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006a:	eb 12                	jmp    80007e <_main+0x46>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80006c:	ff 45 f0             	incl   -0x10(%ebp)
  80006f:	a1 20 30 80 00       	mov    0x803020,%eax
  800074:	8b 50 74             	mov    0x74(%eax),%edx
  800077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007a:	39 c2                	cmp    %eax,%edx
  80007c:	77 ce                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80007e:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800082:	74 14                	je     800098 <_main+0x60>
  800084:	83 ec 04             	sub    $0x4,%esp
  800087:	68 a0 23 80 00       	push   $0x8023a0
  80008c:	6a 12                	push   $0x12
  80008e:	68 bc 23 80 00       	push   $0x8023bc
  800093:	e8 94 04 00 00       	call   80052c <_panic>
	}

	cprintf("************************************************\n");
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	68 d8 23 80 00       	push   $0x8023d8
  8000a0:	e8 29 07 00 00       	call   8007ce <cprintf>
  8000a5:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	68 0c 24 80 00       	push   $0x80240c
  8000b0:	e8 19 07 00 00       	call   8007ce <cprintf>
  8000b5:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	68 68 24 80 00       	push   $0x802468
  8000c0:	e8 09 07 00 00       	call   8007ce <cprintf>
  8000c5:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000c8:	e8 cd 19 00 00       	call   801a9a <sys_getenvid>
  8000cd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	68 9c 24 80 00       	push   $0x80249c
  8000d8:	e8 f1 06 00 00       	call   8007ce <cprintf>
  8000dd:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int32 envIdSlave1 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e5:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8000eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f0:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  8000f6:	89 c1                	mov    %eax,%ecx
  8000f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fd:	8b 40 74             	mov    0x74(%eax),%eax
  800100:	52                   	push   %edx
  800101:	51                   	push   %ecx
  800102:	50                   	push   %eax
  800103:	68 dd 24 80 00       	push   $0x8024dd
  800108:	e8 c6 1c 00 00       	call   801dd3 <sys_create_env>
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int32 envIdSlave2 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800113:	a1 20 30 80 00       	mov    0x803020,%eax
  800118:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  80011e:	a1 20 30 80 00       	mov    0x803020,%eax
  800123:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  800129:	89 c1                	mov    %eax,%ecx
  80012b:	a1 20 30 80 00       	mov    0x803020,%eax
  800130:	8b 40 74             	mov    0x74(%eax),%eax
  800133:	52                   	push   %edx
  800134:	51                   	push   %ecx
  800135:	50                   	push   %eax
  800136:	68 dd 24 80 00       	push   $0x8024dd
  80013b:	e8 93 1c 00 00       	call   801dd3 <sys_create_env>
  800140:	83 c4 10             	add    $0x10,%esp
  800143:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800146:	e8 33 1a 00 00       	call   801b7e <sys_calculate_free_frames>
  80014b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	6a 01                	push   $0x1
  800153:	68 00 10 00 00       	push   $0x1000
  800158:	68 e8 24 80 00       	push   $0x8024e8
  80015d:	e8 6c 17 00 00       	call   8018ce <smalloc>
  800162:	83 c4 10             	add    $0x10,%esp
  800165:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  800168:	83 ec 0c             	sub    $0xc,%esp
  80016b:	68 ec 24 80 00       	push   $0x8024ec
  800170:	e8 59 06 00 00       	call   8007ce <cprintf>
  800175:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800178:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 0c 25 80 00       	push   $0x80250c
  800189:	6a 24                	push   $0x24
  80018b:	68 bc 23 80 00       	push   $0x8023bc
  800190:	e8 97 03 00 00       	call   80052c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800195:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800198:	e8 e1 19 00 00       	call   801b7e <sys_calculate_free_frames>
  80019d:	29 c3                	sub    %eax,%ebx
  80019f:	89 d8                	mov    %ebx,%eax
  8001a1:	83 f8 04             	cmp    $0x4,%eax
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 78 25 80 00       	push   $0x802578
  8001ae:	6a 25                	push   $0x25
  8001b0:	68 bc 23 80 00       	push   $0x8023bc
  8001b5:	e8 72 03 00 00       	call   80052c <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001ba:	e8 fc 1c 00 00       	call   801ebb <rsttst>

		sys_run_env(envIdSlave1);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c5:	e8 27 1c 00 00       	call   801df1 <sys_run_env>
  8001ca:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d3:	e8 19 1c 00 00       	call   801df1 <sys_run_env>
  8001d8:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001db:	83 ec 0c             	sub    $0xc,%esp
  8001de:	68 f6 25 80 00       	push   $0x8025f6
  8001e3:	e8 e6 05 00 00       	call   8007ce <cprintf>
  8001e8:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001eb:	83 ec 0c             	sub    $0xc,%esp
  8001ee:	68 b8 0b 00 00       	push   $0xbb8
  8001f3:	e8 77 1e 00 00       	call   80206f <env_sleep>
  8001f8:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  8001fb:	e8 35 1d 00 00       	call   801f35 <gettst>
  800200:	83 f8 02             	cmp    $0x2,%eax
  800203:	74 14                	je     800219 <_main+0x1e1>
  800205:	83 ec 04             	sub    $0x4,%esp
  800208:	68 0d 26 80 00       	push   $0x80260d
  80020d:	6a 31                	push   $0x31
  80020f:	68 bc 23 80 00       	push   $0x8023bc
  800214:	e8 13 03 00 00       	call   80052c <_panic>

		sfree(x);
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	ff 75 dc             	pushl  -0x24(%ebp)
  80021f:	e8 ea 16 00 00       	call   80190e <sfree>
  800224:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	68 1c 26 80 00       	push   $0x80261c
  80022f:	e8 9a 05 00 00       	call   8007ce <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800237:	e8 42 19 00 00       	call   801b7e <sys_calculate_free_frames>
  80023c:	89 c2                	mov    %eax,%edx
  80023e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800241:	29 c2                	sub    %eax,%edx
  800243:	89 d0                	mov    %edx,%eax
  800245:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  800248:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80024c:	74 14                	je     800262 <_main+0x22a>
  80024e:	83 ec 04             	sub    $0x4,%esp
  800251:	68 3c 26 80 00       	push   $0x80263c
  800256:	6a 36                	push   $0x36
  800258:	68 bc 23 80 00       	push   $0x8023bc
  80025d:	e8 ca 02 00 00       	call   80052c <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 6c 26 80 00       	push   $0x80266c
  80026a:	e8 5f 05 00 00       	call   8007ce <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 90 26 80 00       	push   $0x802690
  80027a:	e8 4f 05 00 00       	call   8007ce <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int32 envIdSlaveB1 = sys_create_env("tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800282:	a1 20 30 80 00       	mov    0x803020,%eax
  800287:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  80028d:	a1 20 30 80 00       	mov    0x803020,%eax
  800292:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  800298:	89 c1                	mov    %eax,%ecx
  80029a:	a1 20 30 80 00       	mov    0x803020,%eax
  80029f:	8b 40 74             	mov    0x74(%eax),%eax
  8002a2:	52                   	push   %edx
  8002a3:	51                   	push   %ecx
  8002a4:	50                   	push   %eax
  8002a5:	68 c0 26 80 00       	push   $0x8026c0
  8002aa:	e8 24 1b 00 00       	call   801dd3 <sys_create_env>
  8002af:	83 c4 10             	add    $0x10,%esp
  8002b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int32 envIdSlaveB2 = sys_create_env("tshr5slaveB2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ba:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8002c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c5:	8b 80 c4 3c 01 00    	mov    0x13cc4(%eax),%eax
  8002cb:	89 c1                	mov    %eax,%ecx
  8002cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d2:	8b 40 74             	mov    0x74(%eax),%eax
  8002d5:	52                   	push   %edx
  8002d6:	51                   	push   %ecx
  8002d7:	50                   	push   %eax
  8002d8:	68 cd 26 80 00       	push   $0x8026cd
  8002dd:	e8 f1 1a 00 00       	call   801dd3 <sys_create_env>
  8002e2:	83 c4 10             	add    $0x10,%esp
  8002e5:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	6a 01                	push   $0x1
  8002ed:	68 00 10 00 00       	push   $0x1000
  8002f2:	68 da 26 80 00       	push   $0x8026da
  8002f7:	e8 d2 15 00 00       	call   8018ce <smalloc>
  8002fc:	83 c4 10             	add    $0x10,%esp
  8002ff:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  800302:	83 ec 0c             	sub    $0xc,%esp
  800305:	68 dc 26 80 00       	push   $0x8026dc
  80030a:	e8 bf 04 00 00       	call   8007ce <cprintf>
  80030f:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800312:	83 ec 04             	sub    $0x4,%esp
  800315:	6a 01                	push   $0x1
  800317:	68 00 10 00 00       	push   $0x1000
  80031c:	68 e8 24 80 00       	push   $0x8024e8
  800321:	e8 a8 15 00 00       	call   8018ce <smalloc>
  800326:	83 c4 10             	add    $0x10,%esp
  800329:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	68 ec 24 80 00       	push   $0x8024ec
  800334:	e8 95 04 00 00       	call   8007ce <cprintf>
  800339:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80033c:	e8 7a 1b 00 00       	call   801ebb <rsttst>

		sys_run_env(envIdSlaveB1);
  800341:	83 ec 0c             	sub    $0xc,%esp
  800344:	ff 75 d4             	pushl  -0x2c(%ebp)
  800347:	e8 a5 1a 00 00       	call   801df1 <sys_run_env>
  80034c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	ff 75 d0             	pushl  -0x30(%ebp)
  800355:	e8 97 1a 00 00       	call   801df1 <sys_run_env>
  80035a:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  80035d:	83 ec 0c             	sub    $0xc,%esp
  800360:	68 a0 0f 00 00       	push   $0xfa0
  800365:	e8 05 1d 00 00       	call   80206f <env_sleep>
  80036a:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  80036d:	e8 0c 18 00 00       	call   801b7e <sys_calculate_free_frames>
  800372:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800375:	83 ec 0c             	sub    $0xc,%esp
  800378:	ff 75 cc             	pushl  -0x34(%ebp)
  80037b:	e8 8e 15 00 00       	call   80190e <sfree>
  800380:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800383:	83 ec 0c             	sub    $0xc,%esp
  800386:	68 fc 26 80 00       	push   $0x8026fc
  80038b:	e8 3e 04 00 00       	call   8007ce <cprintf>
  800390:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	ff 75 c8             	pushl  -0x38(%ebp)
  800399:	e8 70 15 00 00       	call   80190e <sfree>
  80039e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003a1:	83 ec 0c             	sub    $0xc,%esp
  8003a4:	68 12 27 80 00       	push   $0x802712
  8003a9:	e8 20 04 00 00       	call   8007ce <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003b1:	e8 c8 17 00 00       	call   801b7e <sys_calculate_free_frames>
  8003b6:	89 c2                	mov    %eax,%edx
  8003b8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003bb:	29 c2                	sub    %eax,%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003c2:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  8003c6:	74 14                	je     8003dc <_main+0x3a4>
  8003c8:	83 ec 04             	sub    $0x4,%esp
  8003cb:	68 28 27 80 00       	push   $0x802728
  8003d0:	6a 57                	push   $0x57
  8003d2:	68 bc 23 80 00       	push   $0x8023bc
  8003d7:	e8 50 01 00 00       	call   80052c <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003dc:	e8 3a 1b 00 00       	call   801f1b <inctst>


	}


	return;
  8003e1:	90                   	nop
}
  8003e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003e5:	c9                   	leave  
  8003e6:	c3                   	ret    

008003e7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003ed:	e8 c1 16 00 00       	call   801ab3 <sys_getenvindex>
  8003f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003f8:	89 d0                	mov    %edx,%eax
  8003fa:	c1 e0 03             	shl    $0x3,%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800406:	01 c8                	add    %ecx,%eax
  800408:	01 c0                	add    %eax,%eax
  80040a:	01 d0                	add    %edx,%eax
  80040c:	01 c0                	add    %eax,%eax
  80040e:	01 d0                	add    %edx,%eax
  800410:	89 c2                	mov    %eax,%edx
  800412:	c1 e2 05             	shl    $0x5,%edx
  800415:	29 c2                	sub    %eax,%edx
  800417:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80041e:	89 c2                	mov    %eax,%edx
  800420:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800426:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80042b:	a1 20 30 80 00       	mov    0x803020,%eax
  800430:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800436:	84 c0                	test   %al,%al
  800438:	74 0f                	je     800449 <libmain+0x62>
		binaryname = myEnv->prog_name;
  80043a:	a1 20 30 80 00       	mov    0x803020,%eax
  80043f:	05 40 3c 01 00       	add    $0x13c40,%eax
  800444:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800449:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80044d:	7e 0a                	jle    800459 <libmain+0x72>
		binaryname = argv[0];
  80044f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800452:	8b 00                	mov    (%eax),%eax
  800454:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800459:	83 ec 08             	sub    $0x8,%esp
  80045c:	ff 75 0c             	pushl  0xc(%ebp)
  80045f:	ff 75 08             	pushl  0x8(%ebp)
  800462:	e8 d1 fb ff ff       	call   800038 <_main>
  800467:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80046a:	e8 df 17 00 00       	call   801c4e <sys_disable_interrupt>
	cprintf("**************************************\n");
  80046f:	83 ec 0c             	sub    $0xc,%esp
  800472:	68 e8 27 80 00       	push   $0x8027e8
  800477:	e8 52 03 00 00       	call   8007ce <cprintf>
  80047c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80047f:	a1 20 30 80 00       	mov    0x803020,%eax
  800484:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80048a:	a1 20 30 80 00       	mov    0x803020,%eax
  80048f:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800495:	83 ec 04             	sub    $0x4,%esp
  800498:	52                   	push   %edx
  800499:	50                   	push   %eax
  80049a:	68 10 28 80 00       	push   $0x802810
  80049f:	e8 2a 03 00 00       	call   8007ce <cprintf>
  8004a4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8004a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ac:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8004b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b7:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8004bd:	83 ec 04             	sub    $0x4,%esp
  8004c0:	52                   	push   %edx
  8004c1:	50                   	push   %eax
  8004c2:	68 38 28 80 00       	push   $0x802838
  8004c7:	e8 02 03 00 00       	call   8007ce <cprintf>
  8004cc:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d4:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8004da:	83 ec 08             	sub    $0x8,%esp
  8004dd:	50                   	push   %eax
  8004de:	68 79 28 80 00       	push   $0x802879
  8004e3:	e8 e6 02 00 00       	call   8007ce <cprintf>
  8004e8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004eb:	83 ec 0c             	sub    $0xc,%esp
  8004ee:	68 e8 27 80 00       	push   $0x8027e8
  8004f3:	e8 d6 02 00 00       	call   8007ce <cprintf>
  8004f8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004fb:	e8 68 17 00 00       	call   801c68 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800500:	e8 19 00 00 00       	call   80051e <exit>
}
  800505:	90                   	nop
  800506:	c9                   	leave  
  800507:	c3                   	ret    

00800508 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800508:	55                   	push   %ebp
  800509:	89 e5                	mov    %esp,%ebp
  80050b:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80050e:	83 ec 0c             	sub    $0xc,%esp
  800511:	6a 00                	push   $0x0
  800513:	e8 67 15 00 00       	call   801a7f <sys_env_destroy>
  800518:	83 c4 10             	add    $0x10,%esp
}
  80051b:	90                   	nop
  80051c:	c9                   	leave  
  80051d:	c3                   	ret    

0080051e <exit>:

void
exit(void)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800524:	e8 bc 15 00 00       	call   801ae5 <sys_env_exit>
}
  800529:	90                   	nop
  80052a:	c9                   	leave  
  80052b:	c3                   	ret    

0080052c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
  80052f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800532:	8d 45 10             	lea    0x10(%ebp),%eax
  800535:	83 c0 04             	add    $0x4,%eax
  800538:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80053b:	a1 18 31 80 00       	mov    0x803118,%eax
  800540:	85 c0                	test   %eax,%eax
  800542:	74 16                	je     80055a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800544:	a1 18 31 80 00       	mov    0x803118,%eax
  800549:	83 ec 08             	sub    $0x8,%esp
  80054c:	50                   	push   %eax
  80054d:	68 90 28 80 00       	push   $0x802890
  800552:	e8 77 02 00 00       	call   8007ce <cprintf>
  800557:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80055a:	a1 00 30 80 00       	mov    0x803000,%eax
  80055f:	ff 75 0c             	pushl  0xc(%ebp)
  800562:	ff 75 08             	pushl  0x8(%ebp)
  800565:	50                   	push   %eax
  800566:	68 95 28 80 00       	push   $0x802895
  80056b:	e8 5e 02 00 00       	call   8007ce <cprintf>
  800570:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800573:	8b 45 10             	mov    0x10(%ebp),%eax
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	ff 75 f4             	pushl  -0xc(%ebp)
  80057c:	50                   	push   %eax
  80057d:	e8 e1 01 00 00       	call   800763 <vcprintf>
  800582:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	6a 00                	push   $0x0
  80058a:	68 b1 28 80 00       	push   $0x8028b1
  80058f:	e8 cf 01 00 00       	call   800763 <vcprintf>
  800594:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800597:	e8 82 ff ff ff       	call   80051e <exit>

	// should not return here
	while (1) ;
  80059c:	eb fe                	jmp    80059c <_panic+0x70>

0080059e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
  8005a1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005a4:	a1 20 30 80 00       	mov    0x803020,%eax
  8005a9:	8b 50 74             	mov    0x74(%eax),%edx
  8005ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005af:	39 c2                	cmp    %eax,%edx
  8005b1:	74 14                	je     8005c7 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005b3:	83 ec 04             	sub    $0x4,%esp
  8005b6:	68 b4 28 80 00       	push   $0x8028b4
  8005bb:	6a 26                	push   $0x26
  8005bd:	68 00 29 80 00       	push   $0x802900
  8005c2:	e8 65 ff ff ff       	call   80052c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005d5:	e9 b6 00 00 00       	jmp    800690 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8005da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	01 d0                	add    %edx,%eax
  8005e9:	8b 00                	mov    (%eax),%eax
  8005eb:	85 c0                	test   %eax,%eax
  8005ed:	75 08                	jne    8005f7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005ef:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005f2:	e9 96 00 00 00       	jmp    80068d <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8005f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005fe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800605:	eb 5d                	jmp    800664 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800607:	a1 20 30 80 00       	mov    0x803020,%eax
  80060c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800612:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800615:	c1 e2 04             	shl    $0x4,%edx
  800618:	01 d0                	add    %edx,%eax
  80061a:	8a 40 04             	mov    0x4(%eax),%al
  80061d:	84 c0                	test   %al,%al
  80061f:	75 40                	jne    800661 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800621:	a1 20 30 80 00       	mov    0x803020,%eax
  800626:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80062c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80062f:	c1 e2 04             	shl    $0x4,%edx
  800632:	01 d0                	add    %edx,%eax
  800634:	8b 00                	mov    (%eax),%eax
  800636:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800639:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80063c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800641:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800646:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80064d:	8b 45 08             	mov    0x8(%ebp),%eax
  800650:	01 c8                	add    %ecx,%eax
  800652:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800654:	39 c2                	cmp    %eax,%edx
  800656:	75 09                	jne    800661 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800658:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80065f:	eb 12                	jmp    800673 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800661:	ff 45 e8             	incl   -0x18(%ebp)
  800664:	a1 20 30 80 00       	mov    0x803020,%eax
  800669:	8b 50 74             	mov    0x74(%eax),%edx
  80066c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80066f:	39 c2                	cmp    %eax,%edx
  800671:	77 94                	ja     800607 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800673:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800677:	75 14                	jne    80068d <CheckWSWithoutLastIndex+0xef>
			panic(
  800679:	83 ec 04             	sub    $0x4,%esp
  80067c:	68 0c 29 80 00       	push   $0x80290c
  800681:	6a 3a                	push   $0x3a
  800683:	68 00 29 80 00       	push   $0x802900
  800688:	e8 9f fe ff ff       	call   80052c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80068d:	ff 45 f0             	incl   -0x10(%ebp)
  800690:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800693:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800696:	0f 8c 3e ff ff ff    	jl     8005da <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80069c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006aa:	eb 20                	jmp    8006cc <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006ac:	a1 20 30 80 00       	mov    0x803020,%eax
  8006b1:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8006b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006ba:	c1 e2 04             	shl    $0x4,%edx
  8006bd:	01 d0                	add    %edx,%eax
  8006bf:	8a 40 04             	mov    0x4(%eax),%al
  8006c2:	3c 01                	cmp    $0x1,%al
  8006c4:	75 03                	jne    8006c9 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8006c6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006c9:	ff 45 e0             	incl   -0x20(%ebp)
  8006cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8006d1:	8b 50 74             	mov    0x74(%eax),%edx
  8006d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d7:	39 c2                	cmp    %eax,%edx
  8006d9:	77 d1                	ja     8006ac <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006de:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006e1:	74 14                	je     8006f7 <CheckWSWithoutLastIndex+0x159>
		panic(
  8006e3:	83 ec 04             	sub    $0x4,%esp
  8006e6:	68 60 29 80 00       	push   $0x802960
  8006eb:	6a 44                	push   $0x44
  8006ed:	68 00 29 80 00       	push   $0x802900
  8006f2:	e8 35 fe ff ff       	call   80052c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006f7:	90                   	nop
  8006f8:	c9                   	leave  
  8006f9:	c3                   	ret    

008006fa <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006fa:	55                   	push   %ebp
  8006fb:	89 e5                	mov    %esp,%ebp
  8006fd:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800700:	8b 45 0c             	mov    0xc(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	8d 48 01             	lea    0x1(%eax),%ecx
  800708:	8b 55 0c             	mov    0xc(%ebp),%edx
  80070b:	89 0a                	mov    %ecx,(%edx)
  80070d:	8b 55 08             	mov    0x8(%ebp),%edx
  800710:	88 d1                	mov    %dl,%cl
  800712:	8b 55 0c             	mov    0xc(%ebp),%edx
  800715:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800719:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800723:	75 2c                	jne    800751 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800725:	a0 24 30 80 00       	mov    0x803024,%al
  80072a:	0f b6 c0             	movzbl %al,%eax
  80072d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800730:	8b 12                	mov    (%edx),%edx
  800732:	89 d1                	mov    %edx,%ecx
  800734:	8b 55 0c             	mov    0xc(%ebp),%edx
  800737:	83 c2 08             	add    $0x8,%edx
  80073a:	83 ec 04             	sub    $0x4,%esp
  80073d:	50                   	push   %eax
  80073e:	51                   	push   %ecx
  80073f:	52                   	push   %edx
  800740:	e8 f8 12 00 00       	call   801a3d <sys_cputs>
  800745:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800751:	8b 45 0c             	mov    0xc(%ebp),%eax
  800754:	8b 40 04             	mov    0x4(%eax),%eax
  800757:	8d 50 01             	lea    0x1(%eax),%edx
  80075a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800760:	90                   	nop
  800761:	c9                   	leave  
  800762:	c3                   	ret    

00800763 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800763:	55                   	push   %ebp
  800764:	89 e5                	mov    %esp,%ebp
  800766:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80076c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800773:	00 00 00 
	b.cnt = 0;
  800776:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80077d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800780:	ff 75 0c             	pushl  0xc(%ebp)
  800783:	ff 75 08             	pushl  0x8(%ebp)
  800786:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80078c:	50                   	push   %eax
  80078d:	68 fa 06 80 00       	push   $0x8006fa
  800792:	e8 11 02 00 00       	call   8009a8 <vprintfmt>
  800797:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80079a:	a0 24 30 80 00       	mov    0x803024,%al
  80079f:	0f b6 c0             	movzbl %al,%eax
  8007a2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007a8:	83 ec 04             	sub    $0x4,%esp
  8007ab:	50                   	push   %eax
  8007ac:	52                   	push   %edx
  8007ad:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007b3:	83 c0 08             	add    $0x8,%eax
  8007b6:	50                   	push   %eax
  8007b7:	e8 81 12 00 00       	call   801a3d <sys_cputs>
  8007bc:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007bf:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8007c6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007cc:	c9                   	leave  
  8007cd:	c3                   	ret    

008007ce <cprintf>:

int cprintf(const char *fmt, ...) {
  8007ce:	55                   	push   %ebp
  8007cf:	89 e5                	mov    %esp,%ebp
  8007d1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007d4:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8007db:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e4:	83 ec 08             	sub    $0x8,%esp
  8007e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ea:	50                   	push   %eax
  8007eb:	e8 73 ff ff ff       	call   800763 <vcprintf>
  8007f0:	83 c4 10             	add    $0x10,%esp
  8007f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007f9:	c9                   	leave  
  8007fa:	c3                   	ret    

008007fb <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007fb:	55                   	push   %ebp
  8007fc:	89 e5                	mov    %esp,%ebp
  8007fe:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800801:	e8 48 14 00 00       	call   801c4e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800806:	8d 45 0c             	lea    0xc(%ebp),%eax
  800809:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	ff 75 f4             	pushl  -0xc(%ebp)
  800815:	50                   	push   %eax
  800816:	e8 48 ff ff ff       	call   800763 <vcprintf>
  80081b:	83 c4 10             	add    $0x10,%esp
  80081e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800821:	e8 42 14 00 00       	call   801c68 <sys_enable_interrupt>
	return cnt;
  800826:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800829:	c9                   	leave  
  80082a:	c3                   	ret    

0080082b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	53                   	push   %ebx
  80082f:	83 ec 14             	sub    $0x14,%esp
  800832:	8b 45 10             	mov    0x10(%ebp),%eax
  800835:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80083e:	8b 45 18             	mov    0x18(%ebp),%eax
  800841:	ba 00 00 00 00       	mov    $0x0,%edx
  800846:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800849:	77 55                	ja     8008a0 <printnum+0x75>
  80084b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80084e:	72 05                	jb     800855 <printnum+0x2a>
  800850:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800853:	77 4b                	ja     8008a0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800855:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800858:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80085b:	8b 45 18             	mov    0x18(%ebp),%eax
  80085e:	ba 00 00 00 00       	mov    $0x0,%edx
  800863:	52                   	push   %edx
  800864:	50                   	push   %eax
  800865:	ff 75 f4             	pushl  -0xc(%ebp)
  800868:	ff 75 f0             	pushl  -0x10(%ebp)
  80086b:	e8 b4 18 00 00       	call   802124 <__udivdi3>
  800870:	83 c4 10             	add    $0x10,%esp
  800873:	83 ec 04             	sub    $0x4,%esp
  800876:	ff 75 20             	pushl  0x20(%ebp)
  800879:	53                   	push   %ebx
  80087a:	ff 75 18             	pushl  0x18(%ebp)
  80087d:	52                   	push   %edx
  80087e:	50                   	push   %eax
  80087f:	ff 75 0c             	pushl  0xc(%ebp)
  800882:	ff 75 08             	pushl  0x8(%ebp)
  800885:	e8 a1 ff ff ff       	call   80082b <printnum>
  80088a:	83 c4 20             	add    $0x20,%esp
  80088d:	eb 1a                	jmp    8008a9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	ff 75 0c             	pushl  0xc(%ebp)
  800895:	ff 75 20             	pushl  0x20(%ebp)
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	ff d0                	call   *%eax
  80089d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008a0:	ff 4d 1c             	decl   0x1c(%ebp)
  8008a3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008a7:	7f e6                	jg     80088f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008a9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b7:	53                   	push   %ebx
  8008b8:	51                   	push   %ecx
  8008b9:	52                   	push   %edx
  8008ba:	50                   	push   %eax
  8008bb:	e8 74 19 00 00       	call   802234 <__umoddi3>
  8008c0:	83 c4 10             	add    $0x10,%esp
  8008c3:	05 d4 2b 80 00       	add    $0x802bd4,%eax
  8008c8:	8a 00                	mov    (%eax),%al
  8008ca:	0f be c0             	movsbl %al,%eax
  8008cd:	83 ec 08             	sub    $0x8,%esp
  8008d0:	ff 75 0c             	pushl  0xc(%ebp)
  8008d3:	50                   	push   %eax
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	ff d0                	call   *%eax
  8008d9:	83 c4 10             	add    $0x10,%esp
}
  8008dc:	90                   	nop
  8008dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008e0:	c9                   	leave  
  8008e1:	c3                   	ret    

008008e2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008e5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008e9:	7e 1c                	jle    800907 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	8b 00                	mov    (%eax),%eax
  8008f0:	8d 50 08             	lea    0x8(%eax),%edx
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	89 10                	mov    %edx,(%eax)
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	8b 00                	mov    (%eax),%eax
  8008fd:	83 e8 08             	sub    $0x8,%eax
  800900:	8b 50 04             	mov    0x4(%eax),%edx
  800903:	8b 00                	mov    (%eax),%eax
  800905:	eb 40                	jmp    800947 <getuint+0x65>
	else if (lflag)
  800907:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80090b:	74 1e                	je     80092b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	8d 50 04             	lea    0x4(%eax),%edx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	89 10                	mov    %edx,(%eax)
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	83 e8 04             	sub    $0x4,%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	ba 00 00 00 00       	mov    $0x0,%edx
  800929:	eb 1c                	jmp    800947 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	8d 50 04             	lea    0x4(%eax),%edx
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	89 10                	mov    %edx,(%eax)
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	83 e8 04             	sub    $0x4,%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    

00800949 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80094c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800950:	7e 1c                	jle    80096e <getint+0x25>
		return va_arg(*ap, long long);
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	8b 00                	mov    (%eax),%eax
  800957:	8d 50 08             	lea    0x8(%eax),%edx
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	89 10                	mov    %edx,(%eax)
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 00                	mov    (%eax),%eax
  800964:	83 e8 08             	sub    $0x8,%eax
  800967:	8b 50 04             	mov    0x4(%eax),%edx
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	eb 38                	jmp    8009a6 <getint+0x5d>
	else if (lflag)
  80096e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800972:	74 1a                	je     80098e <getint+0x45>
		return va_arg(*ap, long);
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	8b 00                	mov    (%eax),%eax
  800979:	8d 50 04             	lea    0x4(%eax),%edx
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	89 10                	mov    %edx,(%eax)
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	83 e8 04             	sub    $0x4,%eax
  800989:	8b 00                	mov    (%eax),%eax
  80098b:	99                   	cltd   
  80098c:	eb 18                	jmp    8009a6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	8b 00                	mov    (%eax),%eax
  800993:	8d 50 04             	lea    0x4(%eax),%edx
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	89 10                	mov    %edx,(%eax)
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	8b 00                	mov    (%eax),%eax
  8009a0:	83 e8 04             	sub    $0x4,%eax
  8009a3:	8b 00                	mov    (%eax),%eax
  8009a5:	99                   	cltd   
}
  8009a6:	5d                   	pop    %ebp
  8009a7:	c3                   	ret    

008009a8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	56                   	push   %esi
  8009ac:	53                   	push   %ebx
  8009ad:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b0:	eb 17                	jmp    8009c9 <vprintfmt+0x21>
			if (ch == '\0')
  8009b2:	85 db                	test   %ebx,%ebx
  8009b4:	0f 84 af 03 00 00    	je     800d69 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009ba:	83 ec 08             	sub    $0x8,%esp
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	53                   	push   %ebx
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	ff d0                	call   *%eax
  8009c6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cc:	8d 50 01             	lea    0x1(%eax),%edx
  8009cf:	89 55 10             	mov    %edx,0x10(%ebp)
  8009d2:	8a 00                	mov    (%eax),%al
  8009d4:	0f b6 d8             	movzbl %al,%ebx
  8009d7:	83 fb 25             	cmp    $0x25,%ebx
  8009da:	75 d6                	jne    8009b2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009dc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009e0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009e7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009ee:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009f5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ff:	8d 50 01             	lea    0x1(%eax),%edx
  800a02:	89 55 10             	mov    %edx,0x10(%ebp)
  800a05:	8a 00                	mov    (%eax),%al
  800a07:	0f b6 d8             	movzbl %al,%ebx
  800a0a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a0d:	83 f8 55             	cmp    $0x55,%eax
  800a10:	0f 87 2b 03 00 00    	ja     800d41 <vprintfmt+0x399>
  800a16:	8b 04 85 f8 2b 80 00 	mov    0x802bf8(,%eax,4),%eax
  800a1d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a1f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a23:	eb d7                	jmp    8009fc <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a25:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a29:	eb d1                	jmp    8009fc <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a2b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a32:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a35:	89 d0                	mov    %edx,%eax
  800a37:	c1 e0 02             	shl    $0x2,%eax
  800a3a:	01 d0                	add    %edx,%eax
  800a3c:	01 c0                	add    %eax,%eax
  800a3e:	01 d8                	add    %ebx,%eax
  800a40:	83 e8 30             	sub    $0x30,%eax
  800a43:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a46:	8b 45 10             	mov    0x10(%ebp),%eax
  800a49:	8a 00                	mov    (%eax),%al
  800a4b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a4e:	83 fb 2f             	cmp    $0x2f,%ebx
  800a51:	7e 3e                	jle    800a91 <vprintfmt+0xe9>
  800a53:	83 fb 39             	cmp    $0x39,%ebx
  800a56:	7f 39                	jg     800a91 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a58:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a5b:	eb d5                	jmp    800a32 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a60:	83 c0 04             	add    $0x4,%eax
  800a63:	89 45 14             	mov    %eax,0x14(%ebp)
  800a66:	8b 45 14             	mov    0x14(%ebp),%eax
  800a69:	83 e8 04             	sub    $0x4,%eax
  800a6c:	8b 00                	mov    (%eax),%eax
  800a6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a71:	eb 1f                	jmp    800a92 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a77:	79 83                	jns    8009fc <vprintfmt+0x54>
				width = 0;
  800a79:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a80:	e9 77 ff ff ff       	jmp    8009fc <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a85:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a8c:	e9 6b ff ff ff       	jmp    8009fc <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a91:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a96:	0f 89 60 ff ff ff    	jns    8009fc <vprintfmt+0x54>
				width = precision, precision = -1;
  800a9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800aa2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800aa9:	e9 4e ff ff ff       	jmp    8009fc <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800aae:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ab1:	e9 46 ff ff ff       	jmp    8009fc <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ab6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab9:	83 c0 04             	add    $0x4,%eax
  800abc:	89 45 14             	mov    %eax,0x14(%ebp)
  800abf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac2:	83 e8 04             	sub    $0x4,%eax
  800ac5:	8b 00                	mov    (%eax),%eax
  800ac7:	83 ec 08             	sub    $0x8,%esp
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	50                   	push   %eax
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	ff d0                	call   *%eax
  800ad3:	83 c4 10             	add    $0x10,%esp
			break;
  800ad6:	e9 89 02 00 00       	jmp    800d64 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800adb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ade:	83 c0 04             	add    $0x4,%eax
  800ae1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae7:	83 e8 04             	sub    $0x4,%eax
  800aea:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aec:	85 db                	test   %ebx,%ebx
  800aee:	79 02                	jns    800af2 <vprintfmt+0x14a>
				err = -err;
  800af0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800af2:	83 fb 64             	cmp    $0x64,%ebx
  800af5:	7f 0b                	jg     800b02 <vprintfmt+0x15a>
  800af7:	8b 34 9d 40 2a 80 00 	mov    0x802a40(,%ebx,4),%esi
  800afe:	85 f6                	test   %esi,%esi
  800b00:	75 19                	jne    800b1b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b02:	53                   	push   %ebx
  800b03:	68 e5 2b 80 00       	push   $0x802be5
  800b08:	ff 75 0c             	pushl  0xc(%ebp)
  800b0b:	ff 75 08             	pushl  0x8(%ebp)
  800b0e:	e8 5e 02 00 00       	call   800d71 <printfmt>
  800b13:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b16:	e9 49 02 00 00       	jmp    800d64 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b1b:	56                   	push   %esi
  800b1c:	68 ee 2b 80 00       	push   $0x802bee
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	ff 75 08             	pushl  0x8(%ebp)
  800b27:	e8 45 02 00 00       	call   800d71 <printfmt>
  800b2c:	83 c4 10             	add    $0x10,%esp
			break;
  800b2f:	e9 30 02 00 00       	jmp    800d64 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b34:	8b 45 14             	mov    0x14(%ebp),%eax
  800b37:	83 c0 04             	add    $0x4,%eax
  800b3a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b40:	83 e8 04             	sub    $0x4,%eax
  800b43:	8b 30                	mov    (%eax),%esi
  800b45:	85 f6                	test   %esi,%esi
  800b47:	75 05                	jne    800b4e <vprintfmt+0x1a6>
				p = "(null)";
  800b49:	be f1 2b 80 00       	mov    $0x802bf1,%esi
			if (width > 0 && padc != '-')
  800b4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b52:	7e 6d                	jle    800bc1 <vprintfmt+0x219>
  800b54:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b58:	74 67                	je     800bc1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	50                   	push   %eax
  800b61:	56                   	push   %esi
  800b62:	e8 0c 03 00 00       	call   800e73 <strnlen>
  800b67:	83 c4 10             	add    $0x10,%esp
  800b6a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b6d:	eb 16                	jmp    800b85 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b6f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b73:	83 ec 08             	sub    $0x8,%esp
  800b76:	ff 75 0c             	pushl  0xc(%ebp)
  800b79:	50                   	push   %eax
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	ff d0                	call   *%eax
  800b7f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b82:	ff 4d e4             	decl   -0x1c(%ebp)
  800b85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b89:	7f e4                	jg     800b6f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b8b:	eb 34                	jmp    800bc1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b8d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b91:	74 1c                	je     800baf <vprintfmt+0x207>
  800b93:	83 fb 1f             	cmp    $0x1f,%ebx
  800b96:	7e 05                	jle    800b9d <vprintfmt+0x1f5>
  800b98:	83 fb 7e             	cmp    $0x7e,%ebx
  800b9b:	7e 12                	jle    800baf <vprintfmt+0x207>
					putch('?', putdat);
  800b9d:	83 ec 08             	sub    $0x8,%esp
  800ba0:	ff 75 0c             	pushl  0xc(%ebp)
  800ba3:	6a 3f                	push   $0x3f
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	ff d0                	call   *%eax
  800baa:	83 c4 10             	add    $0x10,%esp
  800bad:	eb 0f                	jmp    800bbe <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800baf:	83 ec 08             	sub    $0x8,%esp
  800bb2:	ff 75 0c             	pushl  0xc(%ebp)
  800bb5:	53                   	push   %ebx
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	ff d0                	call   *%eax
  800bbb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bbe:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc1:	89 f0                	mov    %esi,%eax
  800bc3:	8d 70 01             	lea    0x1(%eax),%esi
  800bc6:	8a 00                	mov    (%eax),%al
  800bc8:	0f be d8             	movsbl %al,%ebx
  800bcb:	85 db                	test   %ebx,%ebx
  800bcd:	74 24                	je     800bf3 <vprintfmt+0x24b>
  800bcf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bd3:	78 b8                	js     800b8d <vprintfmt+0x1e5>
  800bd5:	ff 4d e0             	decl   -0x20(%ebp)
  800bd8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bdc:	79 af                	jns    800b8d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bde:	eb 13                	jmp    800bf3 <vprintfmt+0x24b>
				putch(' ', putdat);
  800be0:	83 ec 08             	sub    $0x8,%esp
  800be3:	ff 75 0c             	pushl  0xc(%ebp)
  800be6:	6a 20                	push   $0x20
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	ff d0                	call   *%eax
  800bed:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf0:	ff 4d e4             	decl   -0x1c(%ebp)
  800bf3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bf7:	7f e7                	jg     800be0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bf9:	e9 66 01 00 00       	jmp    800d64 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bfe:	83 ec 08             	sub    $0x8,%esp
  800c01:	ff 75 e8             	pushl  -0x18(%ebp)
  800c04:	8d 45 14             	lea    0x14(%ebp),%eax
  800c07:	50                   	push   %eax
  800c08:	e8 3c fd ff ff       	call   800949 <getint>
  800c0d:	83 c4 10             	add    $0x10,%esp
  800c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c13:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c1c:	85 d2                	test   %edx,%edx
  800c1e:	79 23                	jns    800c43 <vprintfmt+0x29b>
				putch('-', putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	6a 2d                	push   $0x2d
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	ff d0                	call   *%eax
  800c2d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c36:	f7 d8                	neg    %eax
  800c38:	83 d2 00             	adc    $0x0,%edx
  800c3b:	f7 da                	neg    %edx
  800c3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c43:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c4a:	e9 bc 00 00 00       	jmp    800d0b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 e8             	pushl  -0x18(%ebp)
  800c55:	8d 45 14             	lea    0x14(%ebp),%eax
  800c58:	50                   	push   %eax
  800c59:	e8 84 fc ff ff       	call   8008e2 <getuint>
  800c5e:	83 c4 10             	add    $0x10,%esp
  800c61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c64:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c67:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c6e:	e9 98 00 00 00       	jmp    800d0b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c73:	83 ec 08             	sub    $0x8,%esp
  800c76:	ff 75 0c             	pushl  0xc(%ebp)
  800c79:	6a 58                	push   $0x58
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	ff d0                	call   *%eax
  800c80:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c83:	83 ec 08             	sub    $0x8,%esp
  800c86:	ff 75 0c             	pushl  0xc(%ebp)
  800c89:	6a 58                	push   $0x58
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	ff d0                	call   *%eax
  800c90:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	ff 75 0c             	pushl  0xc(%ebp)
  800c99:	6a 58                	push   $0x58
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	ff d0                	call   *%eax
  800ca0:	83 c4 10             	add    $0x10,%esp
			break;
  800ca3:	e9 bc 00 00 00       	jmp    800d64 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ca8:	83 ec 08             	sub    $0x8,%esp
  800cab:	ff 75 0c             	pushl  0xc(%ebp)
  800cae:	6a 30                	push   $0x30
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	ff d0                	call   *%eax
  800cb5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cb8:	83 ec 08             	sub    $0x8,%esp
  800cbb:	ff 75 0c             	pushl  0xc(%ebp)
  800cbe:	6a 78                	push   $0x78
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	ff d0                	call   *%eax
  800cc5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccb:	83 c0 04             	add    $0x4,%eax
  800cce:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd4:	83 e8 04             	sub    $0x4,%eax
  800cd7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cdc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ce3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cea:	eb 1f                	jmp    800d0b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cec:	83 ec 08             	sub    $0x8,%esp
  800cef:	ff 75 e8             	pushl  -0x18(%ebp)
  800cf2:	8d 45 14             	lea    0x14(%ebp),%eax
  800cf5:	50                   	push   %eax
  800cf6:	e8 e7 fb ff ff       	call   8008e2 <getuint>
  800cfb:	83 c4 10             	add    $0x10,%esp
  800cfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d01:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d04:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d0b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d12:	83 ec 04             	sub    $0x4,%esp
  800d15:	52                   	push   %edx
  800d16:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d19:	50                   	push   %eax
  800d1a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d1d:	ff 75 f0             	pushl  -0x10(%ebp)
  800d20:	ff 75 0c             	pushl  0xc(%ebp)
  800d23:	ff 75 08             	pushl  0x8(%ebp)
  800d26:	e8 00 fb ff ff       	call   80082b <printnum>
  800d2b:	83 c4 20             	add    $0x20,%esp
			break;
  800d2e:	eb 34                	jmp    800d64 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d30:	83 ec 08             	sub    $0x8,%esp
  800d33:	ff 75 0c             	pushl  0xc(%ebp)
  800d36:	53                   	push   %ebx
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	ff d0                	call   *%eax
  800d3c:	83 c4 10             	add    $0x10,%esp
			break;
  800d3f:	eb 23                	jmp    800d64 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d41:	83 ec 08             	sub    $0x8,%esp
  800d44:	ff 75 0c             	pushl  0xc(%ebp)
  800d47:	6a 25                	push   $0x25
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	ff d0                	call   *%eax
  800d4e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d51:	ff 4d 10             	decl   0x10(%ebp)
  800d54:	eb 03                	jmp    800d59 <vprintfmt+0x3b1>
  800d56:	ff 4d 10             	decl   0x10(%ebp)
  800d59:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5c:	48                   	dec    %eax
  800d5d:	8a 00                	mov    (%eax),%al
  800d5f:	3c 25                	cmp    $0x25,%al
  800d61:	75 f3                	jne    800d56 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d63:	90                   	nop
		}
	}
  800d64:	e9 47 fc ff ff       	jmp    8009b0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d69:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d6d:	5b                   	pop    %ebx
  800d6e:	5e                   	pop    %esi
  800d6f:	5d                   	pop    %ebp
  800d70:	c3                   	ret    

00800d71 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d77:	8d 45 10             	lea    0x10(%ebp),%eax
  800d7a:	83 c0 04             	add    $0x4,%eax
  800d7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d80:	8b 45 10             	mov    0x10(%ebp),%eax
  800d83:	ff 75 f4             	pushl  -0xc(%ebp)
  800d86:	50                   	push   %eax
  800d87:	ff 75 0c             	pushl  0xc(%ebp)
  800d8a:	ff 75 08             	pushl  0x8(%ebp)
  800d8d:	e8 16 fc ff ff       	call   8009a8 <vprintfmt>
  800d92:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d95:	90                   	nop
  800d96:	c9                   	leave  
  800d97:	c3                   	ret    

00800d98 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9e:	8b 40 08             	mov    0x8(%eax),%eax
  800da1:	8d 50 01             	lea    0x1(%eax),%edx
  800da4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	8b 10                	mov    (%eax),%edx
  800daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db2:	8b 40 04             	mov    0x4(%eax),%eax
  800db5:	39 c2                	cmp    %eax,%edx
  800db7:	73 12                	jae    800dcb <sprintputch+0x33>
		*b->buf++ = ch;
  800db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbc:	8b 00                	mov    (%eax),%eax
  800dbe:	8d 48 01             	lea    0x1(%eax),%ecx
  800dc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc4:	89 0a                	mov    %ecx,(%edx)
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	88 10                	mov    %dl,(%eax)
}
  800dcb:	90                   	nop
  800dcc:	5d                   	pop    %ebp
  800dcd:	c3                   	ret    

00800dce <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	01 d0                	add    %edx,%eax
  800de5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800def:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800df3:	74 06                	je     800dfb <vsnprintf+0x2d>
  800df5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df9:	7f 07                	jg     800e02 <vsnprintf+0x34>
		return -E_INVAL;
  800dfb:	b8 03 00 00 00       	mov    $0x3,%eax
  800e00:	eb 20                	jmp    800e22 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e02:	ff 75 14             	pushl  0x14(%ebp)
  800e05:	ff 75 10             	pushl  0x10(%ebp)
  800e08:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e0b:	50                   	push   %eax
  800e0c:	68 98 0d 80 00       	push   $0x800d98
  800e11:	e8 92 fb ff ff       	call   8009a8 <vprintfmt>
  800e16:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e1c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e2a:	8d 45 10             	lea    0x10(%ebp),%eax
  800e2d:	83 c0 04             	add    $0x4,%eax
  800e30:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e33:	8b 45 10             	mov    0x10(%ebp),%eax
  800e36:	ff 75 f4             	pushl  -0xc(%ebp)
  800e39:	50                   	push   %eax
  800e3a:	ff 75 0c             	pushl  0xc(%ebp)
  800e3d:	ff 75 08             	pushl  0x8(%ebp)
  800e40:	e8 89 ff ff ff       	call   800dce <vsnprintf>
  800e45:	83 c4 10             	add    $0x10,%esp
  800e48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e4e:	c9                   	leave  
  800e4f:	c3                   	ret    

00800e50 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5d:	eb 06                	jmp    800e65 <strlen+0x15>
		n++;
  800e5f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e62:	ff 45 08             	incl   0x8(%ebp)
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	84 c0                	test   %al,%al
  800e6c:	75 f1                	jne    800e5f <strlen+0xf>
		n++;
	return n;
  800e6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e71:	c9                   	leave  
  800e72:	c3                   	ret    

00800e73 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e80:	eb 09                	jmp    800e8b <strnlen+0x18>
		n++;
  800e82:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e85:	ff 45 08             	incl   0x8(%ebp)
  800e88:	ff 4d 0c             	decl   0xc(%ebp)
  800e8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8f:	74 09                	je     800e9a <strnlen+0x27>
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	84 c0                	test   %al,%al
  800e98:	75 e8                	jne    800e82 <strnlen+0xf>
		n++;
	return n;
  800e9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e9d:	c9                   	leave  
  800e9e:	c3                   	ret    

00800e9f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800eab:	90                   	nop
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	8d 50 01             	lea    0x1(%eax),%edx
  800eb2:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ebb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ebe:	8a 12                	mov    (%edx),%dl
  800ec0:	88 10                	mov    %dl,(%eax)
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	84 c0                	test   %al,%al
  800ec6:	75 e4                	jne    800eac <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ecb:	c9                   	leave  
  800ecc:	c3                   	ret    

00800ecd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ed9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ee0:	eb 1f                	jmp    800f01 <strncpy+0x34>
		*dst++ = *src;
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8d 50 01             	lea    0x1(%eax),%edx
  800ee8:	89 55 08             	mov    %edx,0x8(%ebp)
  800eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eee:	8a 12                	mov    (%edx),%dl
  800ef0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef5:	8a 00                	mov    (%eax),%al
  800ef7:	84 c0                	test   %al,%al
  800ef9:	74 03                	je     800efe <strncpy+0x31>
			src++;
  800efb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800efe:	ff 45 fc             	incl   -0x4(%ebp)
  800f01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f04:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f07:	72 d9                	jb     800ee2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f09:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f0c:	c9                   	leave  
  800f0d:	c3                   	ret    

00800f0e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1e:	74 30                	je     800f50 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f20:	eb 16                	jmp    800f38 <strlcpy+0x2a>
			*dst++ = *src++;
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	8d 50 01             	lea    0x1(%eax),%edx
  800f28:	89 55 08             	mov    %edx,0x8(%ebp)
  800f2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f34:	8a 12                	mov    (%edx),%dl
  800f36:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f38:	ff 4d 10             	decl   0x10(%ebp)
  800f3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3f:	74 09                	je     800f4a <strlcpy+0x3c>
  800f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f44:	8a 00                	mov    (%eax),%al
  800f46:	84 c0                	test   %al,%al
  800f48:	75 d8                	jne    800f22 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f50:	8b 55 08             	mov    0x8(%ebp),%edx
  800f53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f56:	29 c2                	sub    %eax,%edx
  800f58:	89 d0                	mov    %edx,%eax
}
  800f5a:	c9                   	leave  
  800f5b:	c3                   	ret    

00800f5c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f5f:	eb 06                	jmp    800f67 <strcmp+0xb>
		p++, q++;
  800f61:	ff 45 08             	incl   0x8(%ebp)
  800f64:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	84 c0                	test   %al,%al
  800f6e:	74 0e                	je     800f7e <strcmp+0x22>
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 10                	mov    (%eax),%dl
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	38 c2                	cmp    %al,%dl
  800f7c:	74 e3                	je     800f61 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	0f b6 d0             	movzbl %al,%edx
  800f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	0f b6 c0             	movzbl %al,%eax
  800f8e:	29 c2                	sub    %eax,%edx
  800f90:	89 d0                	mov    %edx,%eax
}
  800f92:	5d                   	pop    %ebp
  800f93:	c3                   	ret    

00800f94 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f97:	eb 09                	jmp    800fa2 <strncmp+0xe>
		n--, p++, q++;
  800f99:	ff 4d 10             	decl   0x10(%ebp)
  800f9c:	ff 45 08             	incl   0x8(%ebp)
  800f9f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fa2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa6:	74 17                	je     800fbf <strncmp+0x2b>
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	8a 00                	mov    (%eax),%al
  800fad:	84 c0                	test   %al,%al
  800faf:	74 0e                	je     800fbf <strncmp+0x2b>
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	8a 10                	mov    (%eax),%dl
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	38 c2                	cmp    %al,%dl
  800fbd:	74 da                	je     800f99 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fbf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc3:	75 07                	jne    800fcc <strncmp+0x38>
		return 0;
  800fc5:	b8 00 00 00 00       	mov    $0x0,%eax
  800fca:	eb 14                	jmp    800fe0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	8a 00                	mov    (%eax),%al
  800fd1:	0f b6 d0             	movzbl %al,%edx
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	8a 00                	mov    (%eax),%al
  800fd9:	0f b6 c0             	movzbl %al,%eax
  800fdc:	29 c2                	sub    %eax,%edx
  800fde:	89 d0                	mov    %edx,%eax
}
  800fe0:	5d                   	pop    %ebp
  800fe1:	c3                   	ret    

00800fe2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
  800fe5:	83 ec 04             	sub    $0x4,%esp
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fee:	eb 12                	jmp    801002 <strchr+0x20>
		if (*s == c)
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8a 00                	mov    (%eax),%al
  800ff5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ff8:	75 05                	jne    800fff <strchr+0x1d>
			return (char *) s;
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	eb 11                	jmp    801010 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fff:	ff 45 08             	incl   0x8(%ebp)
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	84 c0                	test   %al,%al
  801009:	75 e5                	jne    800ff0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80100b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801010:	c9                   	leave  
  801011:	c3                   	ret    

00801012 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	83 ec 04             	sub    $0x4,%esp
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80101e:	eb 0d                	jmp    80102d <strfind+0x1b>
		if (*s == c)
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801028:	74 0e                	je     801038 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80102a:	ff 45 08             	incl   0x8(%ebp)
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	84 c0                	test   %al,%al
  801034:	75 ea                	jne    801020 <strfind+0xe>
  801036:	eb 01                	jmp    801039 <strfind+0x27>
		if (*s == c)
			break;
  801038:	90                   	nop
	return (char *) s;
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80103c:	c9                   	leave  
  80103d:	c3                   	ret    

0080103e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80104a:	8b 45 10             	mov    0x10(%ebp),%eax
  80104d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801050:	eb 0e                	jmp    801060 <memset+0x22>
		*p++ = c;
  801052:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801055:	8d 50 01             	lea    0x1(%eax),%edx
  801058:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80105b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801060:	ff 4d f8             	decl   -0x8(%ebp)
  801063:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801067:	79 e9                	jns    801052 <memset+0x14>
		*p++ = c;

	return v;
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801080:	eb 16                	jmp    801098 <memcpy+0x2a>
		*d++ = *s++;
  801082:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801085:	8d 50 01             	lea    0x1(%eax),%edx
  801088:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80108e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801091:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801094:	8a 12                	mov    (%edx),%dl
  801096:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801098:	8b 45 10             	mov    0x10(%ebp),%eax
  80109b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109e:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	75 dd                	jne    801082 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010c2:	73 50                	jae    801114 <memmove+0x6a>
  8010c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ca:	01 d0                	add    %edx,%eax
  8010cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010cf:	76 43                	jbe    801114 <memmove+0x6a>
		s += n;
  8010d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010da:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010dd:	eb 10                	jmp    8010ef <memmove+0x45>
			*--d = *--s;
  8010df:	ff 4d f8             	decl   -0x8(%ebp)
  8010e2:	ff 4d fc             	decl   -0x4(%ebp)
  8010e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e8:	8a 10                	mov    (%eax),%dl
  8010ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ed:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f5:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f8:	85 c0                	test   %eax,%eax
  8010fa:	75 e3                	jne    8010df <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010fc:	eb 23                	jmp    801121 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801101:	8d 50 01             	lea    0x1(%eax),%edx
  801104:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801107:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80110a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80110d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801110:	8a 12                	mov    (%edx),%dl
  801112:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801114:	8b 45 10             	mov    0x10(%ebp),%eax
  801117:	8d 50 ff             	lea    -0x1(%eax),%edx
  80111a:	89 55 10             	mov    %edx,0x10(%ebp)
  80111d:	85 c0                	test   %eax,%eax
  80111f:	75 dd                	jne    8010fe <memmove+0x54>
			*d++ = *s++;

	return dst;
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801124:	c9                   	leave  
  801125:	c3                   	ret    

00801126 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801138:	eb 2a                	jmp    801164 <memcmp+0x3e>
		if (*s1 != *s2)
  80113a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113d:	8a 10                	mov    (%eax),%dl
  80113f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	38 c2                	cmp    %al,%dl
  801146:	74 16                	je     80115e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801148:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	0f b6 d0             	movzbl %al,%edx
  801150:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	0f b6 c0             	movzbl %al,%eax
  801158:	29 c2                	sub    %eax,%edx
  80115a:	89 d0                	mov    %edx,%eax
  80115c:	eb 18                	jmp    801176 <memcmp+0x50>
		s1++, s2++;
  80115e:	ff 45 fc             	incl   -0x4(%ebp)
  801161:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801164:	8b 45 10             	mov    0x10(%ebp),%eax
  801167:	8d 50 ff             	lea    -0x1(%eax),%edx
  80116a:	89 55 10             	mov    %edx,0x10(%ebp)
  80116d:	85 c0                	test   %eax,%eax
  80116f:	75 c9                	jne    80113a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801171:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801176:	c9                   	leave  
  801177:	c3                   	ret    

00801178 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80117e:	8b 55 08             	mov    0x8(%ebp),%edx
  801181:	8b 45 10             	mov    0x10(%ebp),%eax
  801184:	01 d0                	add    %edx,%eax
  801186:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801189:	eb 15                	jmp    8011a0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	0f b6 d0             	movzbl %al,%edx
  801193:	8b 45 0c             	mov    0xc(%ebp),%eax
  801196:	0f b6 c0             	movzbl %al,%eax
  801199:	39 c2                	cmp    %eax,%edx
  80119b:	74 0d                	je     8011aa <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80119d:	ff 45 08             	incl   0x8(%ebp)
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011a6:	72 e3                	jb     80118b <memfind+0x13>
  8011a8:	eb 01                	jmp    8011ab <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011aa:	90                   	nop
	return (void *) s;
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ae:	c9                   	leave  
  8011af:	c3                   	ret    

008011b0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011bd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011c4:	eb 03                	jmp    8011c9 <strtol+0x19>
		s++;
  8011c6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	3c 20                	cmp    $0x20,%al
  8011d0:	74 f4                	je     8011c6 <strtol+0x16>
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	8a 00                	mov    (%eax),%al
  8011d7:	3c 09                	cmp    $0x9,%al
  8011d9:	74 eb                	je     8011c6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	3c 2b                	cmp    $0x2b,%al
  8011e2:	75 05                	jne    8011e9 <strtol+0x39>
		s++;
  8011e4:	ff 45 08             	incl   0x8(%ebp)
  8011e7:	eb 13                	jmp    8011fc <strtol+0x4c>
	else if (*s == '-')
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	3c 2d                	cmp    $0x2d,%al
  8011f0:	75 0a                	jne    8011fc <strtol+0x4c>
		s++, neg = 1;
  8011f2:	ff 45 08             	incl   0x8(%ebp)
  8011f5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801200:	74 06                	je     801208 <strtol+0x58>
  801202:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801206:	75 20                	jne    801228 <strtol+0x78>
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3c 30                	cmp    $0x30,%al
  80120f:	75 17                	jne    801228 <strtol+0x78>
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	40                   	inc    %eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	3c 78                	cmp    $0x78,%al
  801219:	75 0d                	jne    801228 <strtol+0x78>
		s += 2, base = 16;
  80121b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80121f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801226:	eb 28                	jmp    801250 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801228:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80122c:	75 15                	jne    801243 <strtol+0x93>
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	3c 30                	cmp    $0x30,%al
  801235:	75 0c                	jne    801243 <strtol+0x93>
		s++, base = 8;
  801237:	ff 45 08             	incl   0x8(%ebp)
  80123a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801241:	eb 0d                	jmp    801250 <strtol+0xa0>
	else if (base == 0)
  801243:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801247:	75 07                	jne    801250 <strtol+0xa0>
		base = 10;
  801249:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	3c 2f                	cmp    $0x2f,%al
  801257:	7e 19                	jle    801272 <strtol+0xc2>
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	3c 39                	cmp    $0x39,%al
  801260:	7f 10                	jg     801272 <strtol+0xc2>
			dig = *s - '0';
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	0f be c0             	movsbl %al,%eax
  80126a:	83 e8 30             	sub    $0x30,%eax
  80126d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801270:	eb 42                	jmp    8012b4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	3c 60                	cmp    $0x60,%al
  801279:	7e 19                	jle    801294 <strtol+0xe4>
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	3c 7a                	cmp    $0x7a,%al
  801282:	7f 10                	jg     801294 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	0f be c0             	movsbl %al,%eax
  80128c:	83 e8 57             	sub    $0x57,%eax
  80128f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801292:	eb 20                	jmp    8012b4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	8a 00                	mov    (%eax),%al
  801299:	3c 40                	cmp    $0x40,%al
  80129b:	7e 39                	jle    8012d6 <strtol+0x126>
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	3c 5a                	cmp    $0x5a,%al
  8012a4:	7f 30                	jg     8012d6 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	8a 00                	mov    (%eax),%al
  8012ab:	0f be c0             	movsbl %al,%eax
  8012ae:	83 e8 37             	sub    $0x37,%eax
  8012b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012ba:	7d 19                	jge    8012d5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012bc:	ff 45 08             	incl   0x8(%ebp)
  8012bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012c6:	89 c2                	mov    %eax,%edx
  8012c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012cb:	01 d0                	add    %edx,%eax
  8012cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012d0:	e9 7b ff ff ff       	jmp    801250 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012d5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012da:	74 08                	je     8012e4 <strtol+0x134>
		*endptr = (char *) s;
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012df:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012e8:	74 07                	je     8012f1 <strtol+0x141>
  8012ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ed:	f7 d8                	neg    %eax
  8012ef:	eb 03                	jmp    8012f4 <strtol+0x144>
  8012f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012f4:	c9                   	leave  
  8012f5:	c3                   	ret    

008012f6 <ltostr>:

void
ltostr(long value, char *str)
{
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
  8012f9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801303:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80130a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80130e:	79 13                	jns    801323 <ltostr+0x2d>
	{
		neg = 1;
  801310:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80131d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801320:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80132b:	99                   	cltd   
  80132c:	f7 f9                	idiv   %ecx
  80132e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801331:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801334:	8d 50 01             	lea    0x1(%eax),%edx
  801337:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80133a:	89 c2                	mov    %eax,%edx
  80133c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133f:	01 d0                	add    %edx,%eax
  801341:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801344:	83 c2 30             	add    $0x30,%edx
  801347:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801349:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80134c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801351:	f7 e9                	imul   %ecx
  801353:	c1 fa 02             	sar    $0x2,%edx
  801356:	89 c8                	mov    %ecx,%eax
  801358:	c1 f8 1f             	sar    $0x1f,%eax
  80135b:	29 c2                	sub    %eax,%edx
  80135d:	89 d0                	mov    %edx,%eax
  80135f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801362:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801365:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80136a:	f7 e9                	imul   %ecx
  80136c:	c1 fa 02             	sar    $0x2,%edx
  80136f:	89 c8                	mov    %ecx,%eax
  801371:	c1 f8 1f             	sar    $0x1f,%eax
  801374:	29 c2                	sub    %eax,%edx
  801376:	89 d0                	mov    %edx,%eax
  801378:	c1 e0 02             	shl    $0x2,%eax
  80137b:	01 d0                	add    %edx,%eax
  80137d:	01 c0                	add    %eax,%eax
  80137f:	29 c1                	sub    %eax,%ecx
  801381:	89 ca                	mov    %ecx,%edx
  801383:	85 d2                	test   %edx,%edx
  801385:	75 9c                	jne    801323 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801387:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80138e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801391:	48                   	dec    %eax
  801392:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801395:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801399:	74 3d                	je     8013d8 <ltostr+0xe2>
		start = 1 ;
  80139b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013a2:	eb 34                	jmp    8013d8 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8013a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013aa:	01 d0                	add    %edx,%eax
  8013ac:	8a 00                	mov    (%eax),%al
  8013ae:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b7:	01 c2                	add    %eax,%edx
  8013b9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bf:	01 c8                	add    %ecx,%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	01 c2                	add    %eax,%edx
  8013cd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013d0:	88 02                	mov    %al,(%edx)
		start++ ;
  8013d2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013d5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013de:	7c c4                	jl     8013a4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013e0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e6:	01 d0                	add    %edx,%eax
  8013e8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013eb:	90                   	nop
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013f4:	ff 75 08             	pushl  0x8(%ebp)
  8013f7:	e8 54 fa ff ff       	call   800e50 <strlen>
  8013fc:	83 c4 04             	add    $0x4,%esp
  8013ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801402:	ff 75 0c             	pushl  0xc(%ebp)
  801405:	e8 46 fa ff ff       	call   800e50 <strlen>
  80140a:	83 c4 04             	add    $0x4,%esp
  80140d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801417:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80141e:	eb 17                	jmp    801437 <strcconcat+0x49>
		final[s] = str1[s] ;
  801420:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	01 c2                	add    %eax,%edx
  801428:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	01 c8                	add    %ecx,%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801434:	ff 45 fc             	incl   -0x4(%ebp)
  801437:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80143a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80143d:	7c e1                	jl     801420 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80143f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801446:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80144d:	eb 1f                	jmp    80146e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80144f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801452:	8d 50 01             	lea    0x1(%eax),%edx
  801455:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801458:	89 c2                	mov    %eax,%edx
  80145a:	8b 45 10             	mov    0x10(%ebp),%eax
  80145d:	01 c2                	add    %eax,%edx
  80145f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801462:	8b 45 0c             	mov    0xc(%ebp),%eax
  801465:	01 c8                	add    %ecx,%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80146b:	ff 45 f8             	incl   -0x8(%ebp)
  80146e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801471:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801474:	7c d9                	jl     80144f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801476:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801479:	8b 45 10             	mov    0x10(%ebp),%eax
  80147c:	01 d0                	add    %edx,%eax
  80147e:	c6 00 00             	movb   $0x0,(%eax)
}
  801481:	90                   	nop
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801487:	8b 45 14             	mov    0x14(%ebp),%eax
  80148a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801490:	8b 45 14             	mov    0x14(%ebp),%eax
  801493:	8b 00                	mov    (%eax),%eax
  801495:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80149c:	8b 45 10             	mov    0x10(%ebp),%eax
  80149f:	01 d0                	add    %edx,%eax
  8014a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014a7:	eb 0c                	jmp    8014b5 <strsplit+0x31>
			*string++ = 0;
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8d 50 01             	lea    0x1(%eax),%edx
  8014af:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 18                	je     8014d6 <strsplit+0x52>
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	8a 00                	mov    (%eax),%al
  8014c3:	0f be c0             	movsbl %al,%eax
  8014c6:	50                   	push   %eax
  8014c7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ca:	e8 13 fb ff ff       	call   800fe2 <strchr>
  8014cf:	83 c4 08             	add    $0x8,%esp
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	75 d3                	jne    8014a9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	8a 00                	mov    (%eax),%al
  8014db:	84 c0                	test   %al,%al
  8014dd:	74 5a                	je     801539 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014df:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e2:	8b 00                	mov    (%eax),%eax
  8014e4:	83 f8 0f             	cmp    $0xf,%eax
  8014e7:	75 07                	jne    8014f0 <strsplit+0x6c>
		{
			return 0;
  8014e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ee:	eb 66                	jmp    801556 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f3:	8b 00                	mov    (%eax),%eax
  8014f5:	8d 48 01             	lea    0x1(%eax),%ecx
  8014f8:	8b 55 14             	mov    0x14(%ebp),%edx
  8014fb:	89 0a                	mov    %ecx,(%edx)
  8014fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801504:	8b 45 10             	mov    0x10(%ebp),%eax
  801507:	01 c2                	add    %eax,%edx
  801509:	8b 45 08             	mov    0x8(%ebp),%eax
  80150c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80150e:	eb 03                	jmp    801513 <strsplit+0x8f>
			string++;
  801510:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	8a 00                	mov    (%eax),%al
  801518:	84 c0                	test   %al,%al
  80151a:	74 8b                	je     8014a7 <strsplit+0x23>
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	8a 00                	mov    (%eax),%al
  801521:	0f be c0             	movsbl %al,%eax
  801524:	50                   	push   %eax
  801525:	ff 75 0c             	pushl  0xc(%ebp)
  801528:	e8 b5 fa ff ff       	call   800fe2 <strchr>
  80152d:	83 c4 08             	add    $0x8,%esp
  801530:	85 c0                	test   %eax,%eax
  801532:	74 dc                	je     801510 <strsplit+0x8c>
			string++;
	}
  801534:	e9 6e ff ff ff       	jmp    8014a7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801539:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80153a:	8b 45 14             	mov    0x14(%ebp),%eax
  80153d:	8b 00                	mov    (%eax),%eax
  80153f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801546:	8b 45 10             	mov    0x10(%ebp),%eax
  801549:	01 d0                	add    %edx,%eax
  80154b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801551:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <malloc>:
struct page pages[(USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE];
uint32 be_space,be_address,first_empty_space,index,ad,
emp_space,find,array_size=0;
int nump,si,ind;
void* malloc(uint32 size)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
  80155b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	//BOOL VARIABLE COUNT FREE SPACES IN MEM
	free_mem_count=0;
  80155e:	c7 05 4c 31 80 00 00 	movl   $0x0,0x80314c
  801565:	00 00 00 
	//BOOL VARIABLE check is there suitable space or not
	find=0;
  801568:	c7 05 48 31 80 00 00 	movl   $0x0,0x803148
  80156f:	00 00 00 
	// Initialize user heap memory (1GB = 2^30)->MAX_NUM
	if(intialize_mem==0)
  801572:	a1 28 30 80 00       	mov    0x803028,%eax
  801577:	85 c0                	test   %eax,%eax
  801579:	75 65                	jne    8015e0 <malloc+0x88>
	{
		for(j=USER_HEAP_START;j<USER_HEAP_MAX;j+=PAGE_SIZE)
  80157b:	c7 05 2c 31 80 00 00 	movl   $0x80000000,0x80312c
  801582:	00 00 80 
  801585:	eb 43                	jmp    8015ca <malloc+0x72>
		{
			pages[array_size].address=j; // store start address of each 4k(Page_size)
  801587:	8b 15 2c 30 80 00    	mov    0x80302c,%edx
  80158d:	a1 2c 31 80 00       	mov    0x80312c,%eax
  801592:	c1 e2 04             	shl    $0x4,%edx
  801595:	81 c2 60 31 80 00    	add    $0x803160,%edx
  80159b:	89 02                	mov    %eax,(%edx)
			pages[array_size].used=0;//not used
  80159d:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8015a2:	c1 e0 04             	shl    $0x4,%eax
  8015a5:	05 64 31 80 00       	add    $0x803164,%eax
  8015aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			array_size+=1;
  8015b0:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8015b5:	40                   	inc    %eax
  8015b6:	a3 2c 30 80 00       	mov    %eax,0x80302c
	//BOOL VARIABLE check is there suitable space or not
	find=0;
	// Initialize user heap memory (1GB = 2^30)->MAX_NUM
	if(intialize_mem==0)
	{
		for(j=USER_HEAP_START;j<USER_HEAP_MAX;j+=PAGE_SIZE)
  8015bb:	a1 2c 31 80 00       	mov    0x80312c,%eax
  8015c0:	05 00 10 00 00       	add    $0x1000,%eax
  8015c5:	a3 2c 31 80 00       	mov    %eax,0x80312c
  8015ca:	a1 2c 31 80 00       	mov    0x80312c,%eax
  8015cf:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  8015d4:	76 b1                	jbe    801587 <malloc+0x2f>
		{
			pages[array_size].address=j; // store start address of each 4k(Page_size)
			pages[array_size].used=0;//not used
			array_size+=1;
		}
		intialize_mem=1;
  8015d6:	c7 05 28 30 80 00 01 	movl   $0x1,0x803028
  8015dd:	00 00 00 
	}
	be_space=MAX_NUM;
  8015e0:	c7 05 5c 31 80 00 00 	movl   $0x40000000,0x80315c
  8015e7:	00 00 40 
	//find upper limit of size and calculate num of pages with given size
	round=ROUNDUP(size/1024,4);
  8015ea:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	c1 e8 0a             	shr    $0xa,%eax
  8015f7:	89 c2                	mov    %eax,%edx
  8015f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fc:	01 d0                	add    %edx,%eax
  8015fe:	48                   	dec    %eax
  8015ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801605:	ba 00 00 00 00       	mov    $0x0,%edx
  80160a:	f7 75 f4             	divl   -0xc(%ebp)
  80160d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801610:	29 d0                	sub    %edx,%eax
  801612:	a3 28 31 80 00       	mov    %eax,0x803128
	no_of_pages=round/4;
  801617:	a1 28 31 80 00       	mov    0x803128,%eax
  80161c:	c1 e8 02             	shr    $0x2,%eax
  80161f:	a3 60 31 a0 00       	mov    %eax,0xa03160
	// find empty spaces in user heap mem
	for(j=0;j<array_size;++j)
  801624:	c7 05 2c 31 80 00 00 	movl   $0x0,0x80312c
  80162b:	00 00 00 
  80162e:	e9 96 00 00 00       	jmp    8016c9 <malloc+0x171>
	{
		if(pages[j].used==0) //check empty pages
  801633:	a1 2c 31 80 00       	mov    0x80312c,%eax
  801638:	c1 e0 04             	shl    $0x4,%eax
  80163b:	05 64 31 80 00       	add    $0x803164,%eax
  801640:	8b 00                	mov    (%eax),%eax
  801642:	85 c0                	test   %eax,%eax
  801644:	75 2a                	jne    801670 <malloc+0x118>
		{
			//first empty space only
			if(free_mem_count==0)
  801646:	a1 4c 31 80 00       	mov    0x80314c,%eax
  80164b:	85 c0                	test   %eax,%eax
  80164d:	75 14                	jne    801663 <malloc+0x10b>
			{
				first_empty_space=pages[j].address;
  80164f:	a1 2c 31 80 00       	mov    0x80312c,%eax
  801654:	c1 e0 04             	shl    $0x4,%eax
  801657:	05 60 31 80 00       	add    $0x803160,%eax
  80165c:	8b 00                	mov    (%eax),%eax
  80165e:	a3 30 31 80 00       	mov    %eax,0x803130
			}
			free_mem_count++; // increment num of free spaces
  801663:	a1 4c 31 80 00       	mov    0x80314c,%eax
  801668:	40                   	inc    %eax
  801669:	a3 4c 31 80 00       	mov    %eax,0x80314c
  80166e:	eb 4e                	jmp    8016be <malloc+0x166>
		}
		else //pages[j].used!=0(==1)used
		{
			// best fit strategy
			emp_space=free_mem_count*PAGE_SIZE;
  801670:	a1 4c 31 80 00       	mov    0x80314c,%eax
  801675:	c1 e0 0c             	shl    $0xc,%eax
  801678:	a3 34 31 80 00       	mov    %eax,0x803134
			// find min space to fit given size in array
			if(be_space>emp_space&&emp_space>=size)
  80167d:	8b 15 5c 31 80 00    	mov    0x80315c,%edx
  801683:	a1 34 31 80 00       	mov    0x803134,%eax
  801688:	39 c2                	cmp    %eax,%edx
  80168a:	76 28                	jbe    8016b4 <malloc+0x15c>
  80168c:	a1 34 31 80 00       	mov    0x803134,%eax
  801691:	3b 45 08             	cmp    0x8(%ebp),%eax
  801694:	72 1e                	jb     8016b4 <malloc+0x15c>
			{
				// reset min value to repeat condition to find suitable space (ms7 mosawi2 aw2kbr b shwi2)
				be_space=emp_space;
  801696:	a1 34 31 80 00       	mov    0x803134,%eax
  80169b:	a3 5c 31 80 00       	mov    %eax,0x80315c
				// set start address of empty space
				be_address=first_empty_space;
  8016a0:	a1 30 31 80 00       	mov    0x803130,%eax
  8016a5:	a3 58 31 80 00       	mov    %eax,0x803158
				find=1;
  8016aa:	c7 05 48 31 80 00 01 	movl   $0x1,0x803148
  8016b1:	00 00 00 
			}
			free_mem_count=0;
  8016b4:	c7 05 4c 31 80 00 00 	movl   $0x0,0x80314c
  8016bb:	00 00 00 
	be_space=MAX_NUM;
	//find upper limit of size and calculate num of pages with given size
	round=ROUNDUP(size/1024,4);
	no_of_pages=round/4;
	// find empty spaces in user heap mem
	for(j=0;j<array_size;++j)
  8016be:	a1 2c 31 80 00       	mov    0x80312c,%eax
  8016c3:	40                   	inc    %eax
  8016c4:	a3 2c 31 80 00       	mov    %eax,0x80312c
  8016c9:	8b 15 2c 31 80 00    	mov    0x80312c,%edx
  8016cf:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8016d4:	39 c2                	cmp    %eax,%edx
  8016d6:	0f 82 57 ff ff ff    	jb     801633 <malloc+0xdb>
			}
			free_mem_count=0;
		}
	}
	// re calc new empty space
	emp_space=free_mem_count*PAGE_SIZE;
  8016dc:	a1 4c 31 80 00       	mov    0x80314c,%eax
  8016e1:	c1 e0 0c             	shl    $0xc,%eax
  8016e4:	a3 34 31 80 00       	mov    %eax,0x803134
	// check if this empty space suitable to fit given size or not
	if(be_space>emp_space&&emp_space>=size)
  8016e9:	8b 15 5c 31 80 00    	mov    0x80315c,%edx
  8016ef:	a1 34 31 80 00       	mov    0x803134,%eax
  8016f4:	39 c2                	cmp    %eax,%edx
  8016f6:	76 1e                	jbe    801716 <malloc+0x1be>
  8016f8:	a1 34 31 80 00       	mov    0x803134,%eax
  8016fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  801700:	72 14                	jb     801716 <malloc+0x1be>
	{
		find=1;
  801702:	c7 05 48 31 80 00 01 	movl   $0x1,0x803148
  801709:	00 00 00 
		// set final start address of empty space
		be_address=first_empty_space;
  80170c:	a1 30 31 80 00       	mov    0x803130,%eax
  801711:	a3 58 31 80 00       	mov    %eax,0x803158
	}
	if(find==0) // no suitable space found
  801716:	a1 48 31 80 00       	mov    0x803148,%eax
  80171b:	85 c0                	test   %eax,%eax
  80171d:	75 0a                	jne    801729 <malloc+0x1d1>
	{
		return NULL;
  80171f:	b8 00 00 00 00       	mov    $0x0,%eax
  801724:	e9 fa 00 00 00       	jmp    801823 <malloc+0x2cb>
	}
	for(j=0;j<array_size;++j)
  801729:	c7 05 2c 31 80 00 00 	movl   $0x0,0x80312c
  801730:	00 00 00 
  801733:	eb 2f                	jmp    801764 <malloc+0x20c>
	{
		if (pages[j].address==be_address)
  801735:	a1 2c 31 80 00       	mov    0x80312c,%eax
  80173a:	c1 e0 04             	shl    $0x4,%eax
  80173d:	05 60 31 80 00       	add    $0x803160,%eax
  801742:	8b 10                	mov    (%eax),%edx
  801744:	a1 58 31 80 00       	mov    0x803158,%eax
  801749:	39 c2                	cmp    %eax,%edx
  80174b:	75 0c                	jne    801759 <malloc+0x201>
		{
			index=j;
  80174d:	a1 2c 31 80 00       	mov    0x80312c,%eax
  801752:	a3 50 31 80 00       	mov    %eax,0x803150
			break;
  801757:	eb 1a                	jmp    801773 <malloc+0x21b>
	}
	if(find==0) // no suitable space found
	{
		return NULL;
	}
	for(j=0;j<array_size;++j)
  801759:	a1 2c 31 80 00       	mov    0x80312c,%eax
  80175e:	40                   	inc    %eax
  80175f:	a3 2c 31 80 00       	mov    %eax,0x80312c
  801764:	8b 15 2c 31 80 00    	mov    0x80312c,%edx
  80176a:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80176f:	39 c2                	cmp    %eax,%edx
  801771:	72 c2                	jb     801735 <malloc+0x1dd>
			index=j;
			break;
		}
	}
	// set num of pages to address in array
	pages[index].num_of_pages=no_of_pages;
  801773:	8b 15 50 31 80 00    	mov    0x803150,%edx
  801779:	a1 60 31 a0 00       	mov    0xa03160,%eax
  80177e:	c1 e2 04             	shl    $0x4,%edx
  801781:	81 c2 68 31 80 00    	add    $0x803168,%edx
  801787:	89 02                	mov    %eax,(%edx)
	pages[index].siize=size;
  801789:	a1 50 31 80 00       	mov    0x803150,%eax
  80178e:	c1 e0 04             	shl    $0x4,%eax
  801791:	8d 90 6c 31 80 00    	lea    0x80316c(%eax),%edx
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	89 02                	mov    %eax,(%edx)
	ind=index;
  80179c:	a1 50 31 80 00       	mov    0x803150,%eax
  8017a1:	a3 3c 31 80 00       	mov    %eax,0x80313c

	// loop in n to reset used value to 1 b3add l pages
	for(j=0;j<no_of_pages;++j)
  8017a6:	c7 05 2c 31 80 00 00 	movl   $0x0,0x80312c
  8017ad:	00 00 00 
  8017b0:	eb 29                	jmp    8017db <malloc+0x283>
	{
		pages[index].used=1;
  8017b2:	a1 50 31 80 00       	mov    0x803150,%eax
  8017b7:	c1 e0 04             	shl    $0x4,%eax
  8017ba:	05 64 31 80 00       	add    $0x803164,%eax
  8017bf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		++index;
  8017c5:	a1 50 31 80 00       	mov    0x803150,%eax
  8017ca:	40                   	inc    %eax
  8017cb:	a3 50 31 80 00       	mov    %eax,0x803150
	pages[index].num_of_pages=no_of_pages;
	pages[index].siize=size;
	ind=index;

	// loop in n to reset used value to 1 b3add l pages
	for(j=0;j<no_of_pages;++j)
  8017d0:	a1 2c 31 80 00       	mov    0x80312c,%eax
  8017d5:	40                   	inc    %eax
  8017d6:	a3 2c 31 80 00       	mov    %eax,0x80312c
  8017db:	8b 15 2c 31 80 00    	mov    0x80312c,%edx
  8017e1:	a1 60 31 a0 00       	mov    0xa03160,%eax
  8017e6:	39 c2                	cmp    %eax,%edx
  8017e8:	72 c8                	jb     8017b2 <malloc+0x25a>
	{
		pages[index].used=1;
		++index;
	}
	// Swap from user heap to kernel
	sys_allocateMem(be_address,size);
  8017ea:	a1 58 31 80 00       	mov    0x803158,%eax
  8017ef:	83 ec 08             	sub    $0x8,%esp
  8017f2:	ff 75 08             	pushl  0x8(%ebp)
  8017f5:	50                   	push   %eax
  8017f6:	e8 ea 03 00 00       	call   801be5 <sys_allocateMem>
  8017fb:	83 c4 10             	add    $0x10,%esp
	ad = be_address;
  8017fe:	a1 58 31 80 00       	mov    0x803158,%eax
  801803:	a3 20 31 80 00       	mov    %eax,0x803120
	si = size/2;
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	d1 e8                	shr    %eax
  80180d:	a3 38 31 80 00       	mov    %eax,0x803138
	nump = no_of_pages/2;
  801812:	a1 60 31 a0 00       	mov    0xa03160,%eax
  801817:	d1 e8                	shr    %eax
  801819:	a3 40 31 80 00       	mov    %eax,0x803140
	return (void*)be_address;
  80181e:	a1 58 31 80 00       	mov    0x803158,%eax
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	return NULL;
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <free>:

uint32 size, maxmam_size,fif;
void free(void* virtual_address)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	83 ec 28             	sub    $0x28,%esp
int index;
	//found index of virtual address
	for(int i=0;i<array_size;i++)
  80182b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801832:	eb 1d                	jmp    801851 <free+0x2c>
	{
		if((void *)pages[i].address == virtual_address)
  801834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801837:	c1 e0 04             	shl    $0x4,%eax
  80183a:	05 60 31 80 00       	add    $0x803160,%eax
  80183f:	8b 00                	mov    (%eax),%eax
  801841:	3b 45 08             	cmp    0x8(%ebp),%eax
  801844:	75 08                	jne    80184e <free+0x29>
		{
			index = i;
  801846:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801849:	89 45 f4             	mov    %eax,-0xc(%ebp)
			break;
  80184c:	eb 0f                	jmp    80185d <free+0x38>
uint32 size, maxmam_size,fif;
void free(void* virtual_address)
{
int index;
	//found index of virtual address
	for(int i=0;i<array_size;i++)
  80184e:	ff 45 f0             	incl   -0x10(%ebp)
  801851:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801854:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801859:	39 c2                	cmp    %eax,%edx
  80185b:	72 d7                	jb     801834 <free+0xf>
			break;
		}
	}

	//get num of pages
	int num_of_pages = pages[index].num_of_pages;
  80185d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801860:	c1 e0 04             	shl    $0x4,%eax
  801863:	05 68 31 80 00       	add    $0x803168,%eax
  801868:	8b 00                	mov    (%eax),%eax
  80186a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	pages[index].num_of_pages=0;
  80186d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801870:	c1 e0 04             	shl    $0x4,%eax
  801873:	05 68 31 80 00       	add    $0x803168,%eax
  801878:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	uint32 va = pages[index].address;
  80187e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801881:	c1 e0 04             	shl    $0x4,%eax
  801884:	05 60 31 80 00       	add    $0x803160,%eax
  801889:	8b 00                	mov    (%eax),%eax
  80188b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//set used to 0
	for(int i=0;i<num_of_pages;i++)
  80188e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801895:	eb 17                	jmp    8018ae <free+0x89>
	{
		pages[index].used=0;
  801897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189a:	c1 e0 04             	shl    $0x4,%eax
  80189d:	05 64 31 80 00       	add    $0x803164,%eax
  8018a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		index++;
  8018a8:	ff 45 f4             	incl   -0xc(%ebp)
	int num_of_pages = pages[index].num_of_pages;
	pages[index].num_of_pages=0;
	uint32 va = pages[index].address;

	//set used to 0
	for(int i=0;i<num_of_pages;i++)
  8018ab:	ff 45 ec             	incl   -0x14(%ebp)
  8018ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018b4:	7c e1                	jl     801897 <free+0x72>
	{
		pages[index].used=0;
		index++;
	}
	// Swap from user heap to kernel
	sys_freeMem(va, num_of_pages*PAGE_SIZE);
  8018b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b9:	c1 e0 0c             	shl    $0xc,%eax
  8018bc:	83 ec 08             	sub    $0x8,%esp
  8018bf:	50                   	push   %eax
  8018c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018c3:	e8 01 03 00 00       	call   801bc9 <sys_freeMem>
  8018c8:	83 c4 10             	add    $0x10,%esp
}
  8018cb:	90                   	nop
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	83 ec 18             	sub    $0x18,%esp
  8018d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d7:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  8018da:	83 ec 04             	sub    $0x4,%esp
  8018dd:	68 50 2d 80 00       	push   $0x802d50
  8018e2:	68 a0 00 00 00       	push   $0xa0
  8018e7:	68 73 2d 80 00       	push   $0x802d73
  8018ec:	e8 3b ec ff ff       	call   80052c <_panic>

008018f1 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018f7:	83 ec 04             	sub    $0x4,%esp
  8018fa:	68 50 2d 80 00       	push   $0x802d50
  8018ff:	68 a6 00 00 00       	push   $0xa6
  801904:	68 73 2d 80 00       	push   $0x802d73
  801909:	e8 1e ec ff ff       	call   80052c <_panic>

0080190e <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801914:	83 ec 04             	sub    $0x4,%esp
  801917:	68 50 2d 80 00       	push   $0x802d50
  80191c:	68 ac 00 00 00       	push   $0xac
  801921:	68 73 2d 80 00       	push   $0x802d73
  801926:	e8 01 ec ff ff       	call   80052c <_panic>

0080192b <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801931:	83 ec 04             	sub    $0x4,%esp
  801934:	68 50 2d 80 00       	push   $0x802d50
  801939:	68 b1 00 00 00       	push   $0xb1
  80193e:	68 73 2d 80 00       	push   $0x802d73
  801943:	e8 e4 eb ff ff       	call   80052c <_panic>

00801948 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80194e:	83 ec 04             	sub    $0x4,%esp
  801951:	68 50 2d 80 00       	push   $0x802d50
  801956:	68 b7 00 00 00       	push   $0xb7
  80195b:	68 73 2d 80 00       	push   $0x802d73
  801960:	e8 c7 eb ff ff       	call   80052c <_panic>

00801965 <shrink>:
}
void shrink(uint32 newSize)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80196b:	83 ec 04             	sub    $0x4,%esp
  80196e:	68 50 2d 80 00       	push   $0x802d50
  801973:	68 bb 00 00 00       	push   $0xbb
  801978:	68 73 2d 80 00       	push   $0x802d73
  80197d:	e8 aa eb ff ff       	call   80052c <_panic>

00801982 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801988:	83 ec 04             	sub    $0x4,%esp
  80198b:	68 50 2d 80 00       	push   $0x802d50
  801990:	68 c0 00 00 00       	push   $0xc0
  801995:	68 73 2d 80 00       	push   $0x802d73
  80199a:	e8 8d eb ff ff       	call   80052c <_panic>

0080199f <halfLast>:
}

void halfLast(){
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 18             	sub    $0x18,%esp
	for(i=array_size;i>pa/2;--i)
	{
		pages[va].used=0;
		va+=PAGE_SIZE;
	}*/
	uint32 halfAdd = ad+si;
  8019a5:	a1 20 31 80 00       	mov    0x803120,%eax
  8019aa:	8b 15 38 31 80 00    	mov    0x803138,%edx
  8019b0:	01 d0                	add    %edx,%eax
  8019b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	ind+=nump;
  8019b5:	8b 15 3c 31 80 00    	mov    0x80313c,%edx
  8019bb:	a1 40 31 80 00       	mov    0x803140,%eax
  8019c0:	01 d0                	add    %edx,%eax
  8019c2:	a3 3c 31 80 00       	mov    %eax,0x80313c
	for(int i=0;i<nump;i++){
  8019c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8019ce:	eb 21                	jmp    8019f1 <halfLast+0x52>
		pages[ind].used=0;
  8019d0:	a1 3c 31 80 00       	mov    0x80313c,%eax
  8019d5:	c1 e0 04             	shl    $0x4,%eax
  8019d8:	05 64 31 80 00       	add    $0x803164,%eax
  8019dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		ind++;
  8019e3:	a1 3c 31 80 00       	mov    0x80313c,%eax
  8019e8:	40                   	inc    %eax
  8019e9:	a3 3c 31 80 00       	mov    %eax,0x80313c
		pages[va].used=0;
		va+=PAGE_SIZE;
	}*/
	uint32 halfAdd = ad+si;
	ind+=nump;
	for(int i=0;i<nump;i++){
  8019ee:	ff 45 f4             	incl   -0xc(%ebp)
  8019f1:	a1 40 31 80 00       	mov    0x803140,%eax
  8019f6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8019f9:	7c d5                	jl     8019d0 <halfLast+0x31>
		pages[ind].used=0;
		ind++;
	}
	sys_freeMem(halfAdd,si);
  8019fb:	a1 38 31 80 00       	mov    0x803138,%eax
  801a00:	83 ec 08             	sub    $0x8,%esp
  801a03:	50                   	push   %eax
  801a04:	ff 75 f0             	pushl  -0x10(%ebp)
  801a07:	e8 bd 01 00 00       	call   801bc9 <sys_freeMem>
  801a0c:	83 c4 10             	add    $0x10,%esp
	//free((void*)ad);
	//malloc(nup);
}
  801a0f:	90                   	nop
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	57                   	push   %edi
  801a16:	56                   	push   %esi
  801a17:	53                   	push   %ebx
  801a18:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a21:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a24:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a27:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a2a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a2d:	cd 30                	int    $0x30
  801a2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a35:	83 c4 10             	add    $0x10,%esp
  801a38:	5b                   	pop    %ebx
  801a39:	5e                   	pop    %esi
  801a3a:	5f                   	pop    %edi
  801a3b:	5d                   	pop    %ebp
  801a3c:	c3                   	ret    

00801a3d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	83 ec 04             	sub    $0x4,%esp
  801a43:	8b 45 10             	mov    0x10(%ebp),%eax
  801a46:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a49:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	52                   	push   %edx
  801a55:	ff 75 0c             	pushl  0xc(%ebp)
  801a58:	50                   	push   %eax
  801a59:	6a 00                	push   $0x0
  801a5b:	e8 b2 ff ff ff       	call   801a12 <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	90                   	nop
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 01                	push   $0x1
  801a75:	e8 98 ff ff ff       	call   801a12 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	50                   	push   %eax
  801a8e:	6a 05                	push   $0x5
  801a90:	e8 7d ff ff ff       	call   801a12 <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 02                	push   $0x2
  801aa9:	e8 64 ff ff ff       	call   801a12 <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 03                	push   $0x3
  801ac2:	e8 4b ff ff ff       	call   801a12 <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 04                	push   $0x4
  801adb:	e8 32 ff ff ff       	call   801a12 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_env_exit>:


void sys_env_exit(void)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 06                	push   $0x6
  801af4:	e8 19 ff ff ff       	call   801a12 <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	90                   	nop
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b05:	8b 45 08             	mov    0x8(%ebp),%eax
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	52                   	push   %edx
  801b0f:	50                   	push   %eax
  801b10:	6a 07                	push   $0x7
  801b12:	e8 fb fe ff ff       	call   801a12 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	56                   	push   %esi
  801b20:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b21:	8b 75 18             	mov    0x18(%ebp),%esi
  801b24:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b27:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	56                   	push   %esi
  801b31:	53                   	push   %ebx
  801b32:	51                   	push   %ecx
  801b33:	52                   	push   %edx
  801b34:	50                   	push   %eax
  801b35:	6a 08                	push   $0x8
  801b37:	e8 d6 fe ff ff       	call   801a12 <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b42:	5b                   	pop    %ebx
  801b43:	5e                   	pop    %esi
  801b44:	5d                   	pop    %ebp
  801b45:	c3                   	ret    

00801b46 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	52                   	push   %edx
  801b56:	50                   	push   %eax
  801b57:	6a 09                	push   $0x9
  801b59:	e8 b4 fe ff ff       	call   801a12 <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	ff 75 0c             	pushl  0xc(%ebp)
  801b6f:	ff 75 08             	pushl  0x8(%ebp)
  801b72:	6a 0a                	push   $0xa
  801b74:	e8 99 fe ff ff       	call   801a12 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 0b                	push   $0xb
  801b8d:	e8 80 fe ff ff       	call   801a12 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 0c                	push   $0xc
  801ba6:	e8 67 fe ff ff       	call   801a12 <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 0d                	push   $0xd
  801bbf:	e8 4e fe ff ff       	call   801a12 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	ff 75 0c             	pushl  0xc(%ebp)
  801bd5:	ff 75 08             	pushl  0x8(%ebp)
  801bd8:	6a 11                	push   $0x11
  801bda:	e8 33 fe ff ff       	call   801a12 <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
	return;
  801be2:	90                   	nop
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	ff 75 0c             	pushl  0xc(%ebp)
  801bf1:	ff 75 08             	pushl  0x8(%ebp)
  801bf4:	6a 12                	push   $0x12
  801bf6:	e8 17 fe ff ff       	call   801a12 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfe:	90                   	nop
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 0e                	push   $0xe
  801c10:	e8 fd fd ff ff       	call   801a12 <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	ff 75 08             	pushl  0x8(%ebp)
  801c28:	6a 0f                	push   $0xf
  801c2a:	e8 e3 fd ff ff       	call   801a12 <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 10                	push   $0x10
  801c43:	e8 ca fd ff ff       	call   801a12 <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
}
  801c4b:	90                   	nop
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 14                	push   $0x14
  801c5d:	e8 b0 fd ff ff       	call   801a12 <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
}
  801c65:	90                   	nop
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 15                	push   $0x15
  801c77:	e8 96 fd ff ff       	call   801a12 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
}
  801c7f:	90                   	nop
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 04             	sub    $0x4,%esp
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c8e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	50                   	push   %eax
  801c9b:	6a 16                	push   $0x16
  801c9d:	e8 70 fd ff ff       	call   801a12 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	90                   	nop
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 17                	push   $0x17
  801cb7:	e8 56 fd ff ff       	call   801a12 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
}
  801cbf:	90                   	nop
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	ff 75 0c             	pushl  0xc(%ebp)
  801cd1:	50                   	push   %eax
  801cd2:	6a 18                	push   $0x18
  801cd4:	e8 39 fd ff ff       	call   801a12 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ce1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	52                   	push   %edx
  801cee:	50                   	push   %eax
  801cef:	6a 1b                	push   $0x1b
  801cf1:	e8 1c fd ff ff       	call   801a12 <syscall>
  801cf6:	83 c4 18             	add    $0x18,%esp
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d01:	8b 45 08             	mov    0x8(%ebp),%eax
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	52                   	push   %edx
  801d0b:	50                   	push   %eax
  801d0c:	6a 19                	push   $0x19
  801d0e:	e8 ff fc ff ff       	call   801a12 <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
}
  801d16:	90                   	nop
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	52                   	push   %edx
  801d29:	50                   	push   %eax
  801d2a:	6a 1a                	push   $0x1a
  801d2c:	e8 e1 fc ff ff       	call   801a12 <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
}
  801d34:	90                   	nop
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	83 ec 04             	sub    $0x4,%esp
  801d3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d40:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d43:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d46:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	6a 00                	push   $0x0
  801d4f:	51                   	push   %ecx
  801d50:	52                   	push   %edx
  801d51:	ff 75 0c             	pushl  0xc(%ebp)
  801d54:	50                   	push   %eax
  801d55:	6a 1c                	push   $0x1c
  801d57:	e8 b6 fc ff ff       	call   801a12 <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d67:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	52                   	push   %edx
  801d71:	50                   	push   %eax
  801d72:	6a 1d                	push   $0x1d
  801d74:	e8 99 fc ff ff       	call   801a12 <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d81:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d87:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	51                   	push   %ecx
  801d8f:	52                   	push   %edx
  801d90:	50                   	push   %eax
  801d91:	6a 1e                	push   $0x1e
  801d93:	e8 7a fc ff ff       	call   801a12 <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da3:	8b 45 08             	mov    0x8(%ebp),%eax
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	52                   	push   %edx
  801dad:	50                   	push   %eax
  801dae:	6a 1f                	push   $0x1f
  801db0:	e8 5d fc ff ff       	call   801a12 <syscall>
  801db5:	83 c4 18             	add    $0x18,%esp
}
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 20                	push   $0x20
  801dc9:	e8 44 fc ff ff       	call   801a12 <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	6a 00                	push   $0x0
  801ddb:	ff 75 14             	pushl  0x14(%ebp)
  801dde:	ff 75 10             	pushl  0x10(%ebp)
  801de1:	ff 75 0c             	pushl  0xc(%ebp)
  801de4:	50                   	push   %eax
  801de5:	6a 21                	push   $0x21
  801de7:	e8 26 fc ff ff       	call   801a12 <syscall>
  801dec:	83 c4 18             	add    $0x18,%esp
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801df4:	8b 45 08             	mov    0x8(%ebp),%eax
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	50                   	push   %eax
  801e00:	6a 22                	push   $0x22
  801e02:	e8 0b fc ff ff       	call   801a12 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
}
  801e0a:	90                   	nop
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801e10:	8b 45 08             	mov    0x8(%ebp),%eax
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	50                   	push   %eax
  801e1c:	6a 23                	push   $0x23
  801e1e:	e8 ef fb ff ff       	call   801a12 <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
}
  801e26:	90                   	nop
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e2f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e32:	8d 50 04             	lea    0x4(%eax),%edx
  801e35:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	52                   	push   %edx
  801e3f:	50                   	push   %eax
  801e40:	6a 24                	push   $0x24
  801e42:	e8 cb fb ff ff       	call   801a12 <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
	return result;
  801e4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e50:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e53:	89 01                	mov    %eax,(%ecx)
  801e55:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	c9                   	leave  
  801e5c:	c2 04 00             	ret    $0x4

00801e5f <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	ff 75 10             	pushl  0x10(%ebp)
  801e69:	ff 75 0c             	pushl  0xc(%ebp)
  801e6c:	ff 75 08             	pushl  0x8(%ebp)
  801e6f:	6a 13                	push   $0x13
  801e71:	e8 9c fb ff ff       	call   801a12 <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
	return ;
  801e79:	90                   	nop
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_rcr2>:
uint32 sys_rcr2()
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 25                	push   $0x25
  801e8b:	e8 82 fb ff ff       	call   801a12 <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 04             	sub    $0x4,%esp
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ea1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	50                   	push   %eax
  801eae:	6a 26                	push   $0x26
  801eb0:	e8 5d fb ff ff       	call   801a12 <syscall>
  801eb5:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb8:	90                   	nop
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <rsttst>:
void rsttst()
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 28                	push   $0x28
  801eca:	e8 43 fb ff ff       	call   801a12 <syscall>
  801ecf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed2:	90                   	nop
}
  801ed3:	c9                   	leave  
  801ed4:	c3                   	ret    

00801ed5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	83 ec 04             	sub    $0x4,%esp
  801edb:	8b 45 14             	mov    0x14(%ebp),%eax
  801ede:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ee1:	8b 55 18             	mov    0x18(%ebp),%edx
  801ee4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ee8:	52                   	push   %edx
  801ee9:	50                   	push   %eax
  801eea:	ff 75 10             	pushl  0x10(%ebp)
  801eed:	ff 75 0c             	pushl  0xc(%ebp)
  801ef0:	ff 75 08             	pushl  0x8(%ebp)
  801ef3:	6a 27                	push   $0x27
  801ef5:	e8 18 fb ff ff       	call   801a12 <syscall>
  801efa:	83 c4 18             	add    $0x18,%esp
	return ;
  801efd:	90                   	nop
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <chktst>:
void chktst(uint32 n)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	ff 75 08             	pushl  0x8(%ebp)
  801f0e:	6a 29                	push   $0x29
  801f10:	e8 fd fa ff ff       	call   801a12 <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
	return ;
  801f18:	90                   	nop
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <inctst>:

void inctst()
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 2a                	push   $0x2a
  801f2a:	e8 e3 fa ff ff       	call   801a12 <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f32:	90                   	nop
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <gettst>:
uint32 gettst()
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 2b                	push   $0x2b
  801f44:	e8 c9 fa ff ff       	call   801a12 <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 2c                	push   $0x2c
  801f60:	e8 ad fa ff ff       	call   801a12 <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
  801f68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f6b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f6f:	75 07                	jne    801f78 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f71:	b8 01 00 00 00       	mov    $0x1,%eax
  801f76:	eb 05                	jmp    801f7d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 2c                	push   $0x2c
  801f91:	e8 7c fa ff ff       	call   801a12 <syscall>
  801f96:	83 c4 18             	add    $0x18,%esp
  801f99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f9c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fa0:	75 07                	jne    801fa9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fa2:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa7:	eb 05                	jmp    801fae <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 2c                	push   $0x2c
  801fc2:	e8 4b fa ff ff       	call   801a12 <syscall>
  801fc7:	83 c4 18             	add    $0x18,%esp
  801fca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fcd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fd1:	75 07                	jne    801fda <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fd3:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd8:	eb 05                	jmp    801fdf <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 2c                	push   $0x2c
  801ff3:	e8 1a fa ff ff       	call   801a12 <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
  801ffb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ffe:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802002:	75 07                	jne    80200b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802004:	b8 01 00 00 00       	mov    $0x1,%eax
  802009:	eb 05                	jmp    802010 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80200b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	ff 75 08             	pushl  0x8(%ebp)
  802020:	6a 2d                	push   $0x2d
  802022:	e8 eb f9 ff ff       	call   801a12 <syscall>
  802027:	83 c4 18             	add    $0x18,%esp
	return ;
  80202a:	90                   	nop
}
  80202b:	c9                   	leave  
  80202c:	c3                   	ret    

0080202d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
  802030:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802031:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802034:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802037:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	6a 00                	push   $0x0
  80203f:	53                   	push   %ebx
  802040:	51                   	push   %ecx
  802041:	52                   	push   %edx
  802042:	50                   	push   %eax
  802043:	6a 2e                	push   $0x2e
  802045:	e8 c8 f9 ff ff       	call   801a12 <syscall>
  80204a:	83 c4 18             	add    $0x18,%esp
}
  80204d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802050:	c9                   	leave  
  802051:	c3                   	ret    

00802052 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802055:	8b 55 0c             	mov    0xc(%ebp),%edx
  802058:	8b 45 08             	mov    0x8(%ebp),%eax
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	52                   	push   %edx
  802062:	50                   	push   %eax
  802063:	6a 2f                	push   $0x2f
  802065:	e8 a8 f9 ff ff       	call   801a12 <syscall>
  80206a:	83 c4 18             	add    $0x18,%esp
}
  80206d:	c9                   	leave  
  80206e:	c3                   	ret    

0080206f <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
  802072:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802075:	8b 55 08             	mov    0x8(%ebp),%edx
  802078:	89 d0                	mov    %edx,%eax
  80207a:	c1 e0 02             	shl    $0x2,%eax
  80207d:	01 d0                	add    %edx,%eax
  80207f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802086:	01 d0                	add    %edx,%eax
  802088:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80208f:	01 d0                	add    %edx,%eax
  802091:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802098:	01 d0                	add    %edx,%eax
  80209a:	c1 e0 04             	shl    $0x4,%eax
  80209d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8020a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8020a7:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8020aa:	83 ec 0c             	sub    $0xc,%esp
  8020ad:	50                   	push   %eax
  8020ae:	e8 76 fd ff ff       	call   801e29 <sys_get_virtual_time>
  8020b3:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8020b6:	eb 41                	jmp    8020f9 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8020b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8020bb:	83 ec 0c             	sub    $0xc,%esp
  8020be:	50                   	push   %eax
  8020bf:	e8 65 fd ff ff       	call   801e29 <sys_get_virtual_time>
  8020c4:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8020c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020cd:	29 c2                	sub    %eax,%edx
  8020cf:	89 d0                	mov    %edx,%eax
  8020d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8020d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020da:	89 d1                	mov    %edx,%ecx
  8020dc:	29 c1                	sub    %eax,%ecx
  8020de:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8020e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020e4:	39 c2                	cmp    %eax,%edx
  8020e6:	0f 97 c0             	seta   %al
  8020e9:	0f b6 c0             	movzbl %al,%eax
  8020ec:	29 c1                	sub    %eax,%ecx
  8020ee:	89 c8                	mov    %ecx,%eax
  8020f0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8020f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8020ff:	72 b7                	jb     8020b8 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802101:	90                   	nop
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80210a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802111:	eb 03                	jmp    802116 <busy_wait+0x12>
  802113:	ff 45 fc             	incl   -0x4(%ebp)
  802116:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802119:	3b 45 08             	cmp    0x8(%ebp),%eax
  80211c:	72 f5                	jb     802113 <busy_wait+0xf>
	return i;
  80211e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    
  802123:	90                   	nop

00802124 <__udivdi3>:
  802124:	55                   	push   %ebp
  802125:	57                   	push   %edi
  802126:	56                   	push   %esi
  802127:	53                   	push   %ebx
  802128:	83 ec 1c             	sub    $0x1c,%esp
  80212b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80212f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802133:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802137:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80213b:	89 ca                	mov    %ecx,%edx
  80213d:	89 f8                	mov    %edi,%eax
  80213f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802143:	85 f6                	test   %esi,%esi
  802145:	75 2d                	jne    802174 <__udivdi3+0x50>
  802147:	39 cf                	cmp    %ecx,%edi
  802149:	77 65                	ja     8021b0 <__udivdi3+0x8c>
  80214b:	89 fd                	mov    %edi,%ebp
  80214d:	85 ff                	test   %edi,%edi
  80214f:	75 0b                	jne    80215c <__udivdi3+0x38>
  802151:	b8 01 00 00 00       	mov    $0x1,%eax
  802156:	31 d2                	xor    %edx,%edx
  802158:	f7 f7                	div    %edi
  80215a:	89 c5                	mov    %eax,%ebp
  80215c:	31 d2                	xor    %edx,%edx
  80215e:	89 c8                	mov    %ecx,%eax
  802160:	f7 f5                	div    %ebp
  802162:	89 c1                	mov    %eax,%ecx
  802164:	89 d8                	mov    %ebx,%eax
  802166:	f7 f5                	div    %ebp
  802168:	89 cf                	mov    %ecx,%edi
  80216a:	89 fa                	mov    %edi,%edx
  80216c:	83 c4 1c             	add    $0x1c,%esp
  80216f:	5b                   	pop    %ebx
  802170:	5e                   	pop    %esi
  802171:	5f                   	pop    %edi
  802172:	5d                   	pop    %ebp
  802173:	c3                   	ret    
  802174:	39 ce                	cmp    %ecx,%esi
  802176:	77 28                	ja     8021a0 <__udivdi3+0x7c>
  802178:	0f bd fe             	bsr    %esi,%edi
  80217b:	83 f7 1f             	xor    $0x1f,%edi
  80217e:	75 40                	jne    8021c0 <__udivdi3+0x9c>
  802180:	39 ce                	cmp    %ecx,%esi
  802182:	72 0a                	jb     80218e <__udivdi3+0x6a>
  802184:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802188:	0f 87 9e 00 00 00    	ja     80222c <__udivdi3+0x108>
  80218e:	b8 01 00 00 00       	mov    $0x1,%eax
  802193:	89 fa                	mov    %edi,%edx
  802195:	83 c4 1c             	add    $0x1c,%esp
  802198:	5b                   	pop    %ebx
  802199:	5e                   	pop    %esi
  80219a:	5f                   	pop    %edi
  80219b:	5d                   	pop    %ebp
  80219c:	c3                   	ret    
  80219d:	8d 76 00             	lea    0x0(%esi),%esi
  8021a0:	31 ff                	xor    %edi,%edi
  8021a2:	31 c0                	xor    %eax,%eax
  8021a4:	89 fa                	mov    %edi,%edx
  8021a6:	83 c4 1c             	add    $0x1c,%esp
  8021a9:	5b                   	pop    %ebx
  8021aa:	5e                   	pop    %esi
  8021ab:	5f                   	pop    %edi
  8021ac:	5d                   	pop    %ebp
  8021ad:	c3                   	ret    
  8021ae:	66 90                	xchg   %ax,%ax
  8021b0:	89 d8                	mov    %ebx,%eax
  8021b2:	f7 f7                	div    %edi
  8021b4:	31 ff                	xor    %edi,%edi
  8021b6:	89 fa                	mov    %edi,%edx
  8021b8:	83 c4 1c             	add    $0x1c,%esp
  8021bb:	5b                   	pop    %ebx
  8021bc:	5e                   	pop    %esi
  8021bd:	5f                   	pop    %edi
  8021be:	5d                   	pop    %ebp
  8021bf:	c3                   	ret    
  8021c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8021c5:	89 eb                	mov    %ebp,%ebx
  8021c7:	29 fb                	sub    %edi,%ebx
  8021c9:	89 f9                	mov    %edi,%ecx
  8021cb:	d3 e6                	shl    %cl,%esi
  8021cd:	89 c5                	mov    %eax,%ebp
  8021cf:	88 d9                	mov    %bl,%cl
  8021d1:	d3 ed                	shr    %cl,%ebp
  8021d3:	89 e9                	mov    %ebp,%ecx
  8021d5:	09 f1                	or     %esi,%ecx
  8021d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8021db:	89 f9                	mov    %edi,%ecx
  8021dd:	d3 e0                	shl    %cl,%eax
  8021df:	89 c5                	mov    %eax,%ebp
  8021e1:	89 d6                	mov    %edx,%esi
  8021e3:	88 d9                	mov    %bl,%cl
  8021e5:	d3 ee                	shr    %cl,%esi
  8021e7:	89 f9                	mov    %edi,%ecx
  8021e9:	d3 e2                	shl    %cl,%edx
  8021eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021ef:	88 d9                	mov    %bl,%cl
  8021f1:	d3 e8                	shr    %cl,%eax
  8021f3:	09 c2                	or     %eax,%edx
  8021f5:	89 d0                	mov    %edx,%eax
  8021f7:	89 f2                	mov    %esi,%edx
  8021f9:	f7 74 24 0c          	divl   0xc(%esp)
  8021fd:	89 d6                	mov    %edx,%esi
  8021ff:	89 c3                	mov    %eax,%ebx
  802201:	f7 e5                	mul    %ebp
  802203:	39 d6                	cmp    %edx,%esi
  802205:	72 19                	jb     802220 <__udivdi3+0xfc>
  802207:	74 0b                	je     802214 <__udivdi3+0xf0>
  802209:	89 d8                	mov    %ebx,%eax
  80220b:	31 ff                	xor    %edi,%edi
  80220d:	e9 58 ff ff ff       	jmp    80216a <__udivdi3+0x46>
  802212:	66 90                	xchg   %ax,%ax
  802214:	8b 54 24 08          	mov    0x8(%esp),%edx
  802218:	89 f9                	mov    %edi,%ecx
  80221a:	d3 e2                	shl    %cl,%edx
  80221c:	39 c2                	cmp    %eax,%edx
  80221e:	73 e9                	jae    802209 <__udivdi3+0xe5>
  802220:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802223:	31 ff                	xor    %edi,%edi
  802225:	e9 40 ff ff ff       	jmp    80216a <__udivdi3+0x46>
  80222a:	66 90                	xchg   %ax,%ax
  80222c:	31 c0                	xor    %eax,%eax
  80222e:	e9 37 ff ff ff       	jmp    80216a <__udivdi3+0x46>
  802233:	90                   	nop

00802234 <__umoddi3>:
  802234:	55                   	push   %ebp
  802235:	57                   	push   %edi
  802236:	56                   	push   %esi
  802237:	53                   	push   %ebx
  802238:	83 ec 1c             	sub    $0x1c,%esp
  80223b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80223f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802243:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802247:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80224b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80224f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802253:	89 f3                	mov    %esi,%ebx
  802255:	89 fa                	mov    %edi,%edx
  802257:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80225b:	89 34 24             	mov    %esi,(%esp)
  80225e:	85 c0                	test   %eax,%eax
  802260:	75 1a                	jne    80227c <__umoddi3+0x48>
  802262:	39 f7                	cmp    %esi,%edi
  802264:	0f 86 a2 00 00 00    	jbe    80230c <__umoddi3+0xd8>
  80226a:	89 c8                	mov    %ecx,%eax
  80226c:	89 f2                	mov    %esi,%edx
  80226e:	f7 f7                	div    %edi
  802270:	89 d0                	mov    %edx,%eax
  802272:	31 d2                	xor    %edx,%edx
  802274:	83 c4 1c             	add    $0x1c,%esp
  802277:	5b                   	pop    %ebx
  802278:	5e                   	pop    %esi
  802279:	5f                   	pop    %edi
  80227a:	5d                   	pop    %ebp
  80227b:	c3                   	ret    
  80227c:	39 f0                	cmp    %esi,%eax
  80227e:	0f 87 ac 00 00 00    	ja     802330 <__umoddi3+0xfc>
  802284:	0f bd e8             	bsr    %eax,%ebp
  802287:	83 f5 1f             	xor    $0x1f,%ebp
  80228a:	0f 84 ac 00 00 00    	je     80233c <__umoddi3+0x108>
  802290:	bf 20 00 00 00       	mov    $0x20,%edi
  802295:	29 ef                	sub    %ebp,%edi
  802297:	89 fe                	mov    %edi,%esi
  802299:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80229d:	89 e9                	mov    %ebp,%ecx
  80229f:	d3 e0                	shl    %cl,%eax
  8022a1:	89 d7                	mov    %edx,%edi
  8022a3:	89 f1                	mov    %esi,%ecx
  8022a5:	d3 ef                	shr    %cl,%edi
  8022a7:	09 c7                	or     %eax,%edi
  8022a9:	89 e9                	mov    %ebp,%ecx
  8022ab:	d3 e2                	shl    %cl,%edx
  8022ad:	89 14 24             	mov    %edx,(%esp)
  8022b0:	89 d8                	mov    %ebx,%eax
  8022b2:	d3 e0                	shl    %cl,%eax
  8022b4:	89 c2                	mov    %eax,%edx
  8022b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022ba:	d3 e0                	shl    %cl,%eax
  8022bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022c4:	89 f1                	mov    %esi,%ecx
  8022c6:	d3 e8                	shr    %cl,%eax
  8022c8:	09 d0                	or     %edx,%eax
  8022ca:	d3 eb                	shr    %cl,%ebx
  8022cc:	89 da                	mov    %ebx,%edx
  8022ce:	f7 f7                	div    %edi
  8022d0:	89 d3                	mov    %edx,%ebx
  8022d2:	f7 24 24             	mull   (%esp)
  8022d5:	89 c6                	mov    %eax,%esi
  8022d7:	89 d1                	mov    %edx,%ecx
  8022d9:	39 d3                	cmp    %edx,%ebx
  8022db:	0f 82 87 00 00 00    	jb     802368 <__umoddi3+0x134>
  8022e1:	0f 84 91 00 00 00    	je     802378 <__umoddi3+0x144>
  8022e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022eb:	29 f2                	sub    %esi,%edx
  8022ed:	19 cb                	sbb    %ecx,%ebx
  8022ef:	89 d8                	mov    %ebx,%eax
  8022f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8022f5:	d3 e0                	shl    %cl,%eax
  8022f7:	89 e9                	mov    %ebp,%ecx
  8022f9:	d3 ea                	shr    %cl,%edx
  8022fb:	09 d0                	or     %edx,%eax
  8022fd:	89 e9                	mov    %ebp,%ecx
  8022ff:	d3 eb                	shr    %cl,%ebx
  802301:	89 da                	mov    %ebx,%edx
  802303:	83 c4 1c             	add    $0x1c,%esp
  802306:	5b                   	pop    %ebx
  802307:	5e                   	pop    %esi
  802308:	5f                   	pop    %edi
  802309:	5d                   	pop    %ebp
  80230a:	c3                   	ret    
  80230b:	90                   	nop
  80230c:	89 fd                	mov    %edi,%ebp
  80230e:	85 ff                	test   %edi,%edi
  802310:	75 0b                	jne    80231d <__umoddi3+0xe9>
  802312:	b8 01 00 00 00       	mov    $0x1,%eax
  802317:	31 d2                	xor    %edx,%edx
  802319:	f7 f7                	div    %edi
  80231b:	89 c5                	mov    %eax,%ebp
  80231d:	89 f0                	mov    %esi,%eax
  80231f:	31 d2                	xor    %edx,%edx
  802321:	f7 f5                	div    %ebp
  802323:	89 c8                	mov    %ecx,%eax
  802325:	f7 f5                	div    %ebp
  802327:	89 d0                	mov    %edx,%eax
  802329:	e9 44 ff ff ff       	jmp    802272 <__umoddi3+0x3e>
  80232e:	66 90                	xchg   %ax,%ax
  802330:	89 c8                	mov    %ecx,%eax
  802332:	89 f2                	mov    %esi,%edx
  802334:	83 c4 1c             	add    $0x1c,%esp
  802337:	5b                   	pop    %ebx
  802338:	5e                   	pop    %esi
  802339:	5f                   	pop    %edi
  80233a:	5d                   	pop    %ebp
  80233b:	c3                   	ret    
  80233c:	3b 04 24             	cmp    (%esp),%eax
  80233f:	72 06                	jb     802347 <__umoddi3+0x113>
  802341:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802345:	77 0f                	ja     802356 <__umoddi3+0x122>
  802347:	89 f2                	mov    %esi,%edx
  802349:	29 f9                	sub    %edi,%ecx
  80234b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80234f:	89 14 24             	mov    %edx,(%esp)
  802352:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802356:	8b 44 24 04          	mov    0x4(%esp),%eax
  80235a:	8b 14 24             	mov    (%esp),%edx
  80235d:	83 c4 1c             	add    $0x1c,%esp
  802360:	5b                   	pop    %ebx
  802361:	5e                   	pop    %esi
  802362:	5f                   	pop    %edi
  802363:	5d                   	pop    %ebp
  802364:	c3                   	ret    
  802365:	8d 76 00             	lea    0x0(%esi),%esi
  802368:	2b 04 24             	sub    (%esp),%eax
  80236b:	19 fa                	sbb    %edi,%edx
  80236d:	89 d1                	mov    %edx,%ecx
  80236f:	89 c6                	mov    %eax,%esi
  802371:	e9 71 ff ff ff       	jmp    8022e7 <__umoddi3+0xb3>
  802376:	66 90                	xchg   %ax,%ax
  802378:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80237c:	72 ea                	jb     802368 <__umoddi3+0x134>
  80237e:	89 d9                	mov    %ebx,%ecx
  802380:	e9 62 ff ff ff       	jmp    8022e7 <__umoddi3+0xb3>
