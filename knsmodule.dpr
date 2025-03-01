// JCL_DEBUG_EXPERT_INSERTJDBG ON
program knsmodule;

uses
  sharemem,
  Forms,
  Windows,
  inifiles,
  Sysutils,
  Dates in 'Dates.pas',
  Desunit in 'desunit.pas',
  ExeParams in 'ExeParams.pas',
  fAddUtilDBF in 'fAddUtilDBF.pas',
  fBases in 'fBases.pas' {Bases: TDataModule},
  fLogFile in 'fLogFile.pas',
  fLogTypeCommand in 'fLogTypeCommand.pas',
  fLogView in 'fLogView.pas' {LogView},
  formEditTreeView in 'formEditTreeView.pas' {FEditTreeView},
  frmEditTreeView in 'frmEditTreeView.pas' {FrameEditTreeView: TFrame},
  frmFETWPanel in 'frmFETWPanel.pas' {frameFETW: TFrame},
  frmQueryModule in 'frmQueryModule.pas' {FrameQueryModule: TFrame},
  frmRepCorrect in 'frmRepCorrect.pas' {fRepCorrect: TFrame},
  frmTreeDataModule in 'frmTreeDataModule.pas' {frameTreeDataModule: TFrame},
  kns3CalcTrServer in 'kns3CalcTrServer.pas',
  kns3SaveTrServer in 'kns3SaveTrServer.pas',
  knseditexpr in 'knseditexpr.pas' {frmEditExpr},
  knsl1comport in 'knsl1comport.pas',
  knsl1cport in 'knsl1cport.pas',
  knsl1editor in 'knsl1editor.pas',
  knsl1gprsrouter in 'knsl1gprsrouter.pas',
  knsl1module in 'knsl1module.pas',
  knsl1tcp in 'knsl1tcp.pas',
  knsl2_HouseTask_16401B in 'knsl2_HouseTask_16401B.pas',
  knsl2_HouseTask_16401M_K in 'knsl2_HouseTask_16401M_K.pas',
  knsl2_HouseTask_A2000 in 'knsl2_HouseTask_A2000.pas',
  knsl2_HouseTask_Global in 'knsl2_HouseTask_Global.pas',
  knsl2_HouseTask_KUB in 'knsl2_HouseTask_KUB.pas',
  knsl2_HouseTask_SSDU in 'knsl2_HouseTask_SSDU.pas',
  knsl2_HouseTask_SSDU_ONE_CHANEL in 'knsl2_HouseTask_SSDU_ONE_CHANEL.pas',
  knsl2_HouseTask_USPD1500 in 'knsl2_HouseTask_USPD1500.pas',
  knsl2_HouseTask_Vzep in 'knsl2_HouseTask_Vzep.pas',
  knsl2_USPD1500 in 'knsl2_USPD1500.pas',
  knsl2a2000meter in 'knsl2a2000meter.pas',
  knsl2BTIInit in 'knsl2BTIInit.pas',
  knsl2BTIModule in 'knsl2BTIModule.pas',
  knsl2C12Module in 'knsl2C12Module.pas',
  knsl2CE06005Meter in 'knsl2CE06005Meter.pas',
  knsl2CE102Meter in 'knsl2CE102Meter.pas',
  knsl2CE16401MMeter in 'knsl2CE16401MMeter.pas',
  knsl2CE16401Mv4 in 'knsl2CE16401Mv4.pas',
  knsl2CE208BYMeter in 'knsl2CE208BYMeter.pas',
  knsl2CE301BYMeter in 'knsl2CE301BYMeter.pas',
  knsl2ce6822meter in 'knsl2ce6822meter.pas',
  knsl2ce6850meter in 'knsl2ce6850meter.pas',
  knsl2CET7007Meter in 'knsl2CET7007Meter.pas',
  knsl2cmdeditor in 'knsl2cmdeditor.pas',
  knsl2cmplgrid in 'knsl2cmplgrid.pas',
  knsl2ControlFrame in 'knsl2ControlFrame.pas' {ControlFrame},
  knsl2CThreadPull in 'knsl2CThreadPull.pas',
  knsl2EA8086Meter in 'knsl2EA8086Meter.pas',
  knsl2editor in 'knsl2editor.pas',
  knsl2ee8005meter in 'knsl2ee8005meter.pas',
  knsl2Factory in 'knsl2Factory.pas',
  knsl2fmtime in 'knsl2FMTime.pas',
  knsl2fqwerymdl in 'knsl2fqwerymdl.pas' {TQweryModule},
  knsl2graphframe in 'knsl2graphframe.pas' {GraphFrame},
  knsl2IRunnable in 'knsl2IRunnable.pas',
  knsl2K2KBytmeter in 'knsl2K2KBytmeter.pas',
  knsl2MES3meter in 'knsl2MES3meter.pas',
  knsl2meter in 'knsl2meter.pas',
  knsl2MIRT1Meter in 'knsl2MIRT1Meter.pas',
  knsl2MIRT1W2Meter in 'knsl2MIRT1W2Meter.pas',
  knsl2module in 'knsl2module.pas',
  knsl2mtypeeditor in 'knsl2mtypeeditor.pas',
  knsl2Nullmeter in 'knsl2Nullmeter.pas',
  knsl2parameditor in 'knsl2parameditor.pas',
  knsl2qmcmdeditor in 'knsl2qmcmdeditor.pas',
  knsl2querybytunloader in 'knsl2querybytunloader.pas',
  knsl2qweryarchmdl in 'knsl2qweryarchmdl.pas',
  knsl2qwerybitserver in 'knsl2qweryBITserver.pas',
  knsl2qwerybytcomm in 'knsl2qwerybytcomm.pas',
  knsl2qwerybytgroup in 'knsl2qwerybytgroup.pas',
  knsl2qwerybytserver in 'knsl2qwerybytserver.pas',
  knsl2qwerybyttmr in 'knsl2qwerybyttmr.pas',
  knsl2qwerymdl in 'knsl2qwerymdl.pas',
  knsl2qweryportpull in 'knsl2qweryportpull.pas',
  knsl2qweryserver in 'knsl2qweryserver.pas',
  knsl2qwerytmr in 'knsl2qwerytmr.pas',
  knsl2QweryTrServer in 'knsl2QweryTrServer.pas',
  knsl2qweryvmeter in 'knsl2qweryvmeter.pas',
  knsl2ss101meter in 'knsl2ss101meter.pas',
  knsl2ss301f3meter in 'knsl2ss301f3meter.pas',
  knsl2SSDUBytmeter in 'knsl2SSDUBytmeter.pas',
  knsl2timers in 'knsl2timers.pas',
  knsl2treehandler in 'knsl2treehandler.pas',
  knsl2treeloader in 'knsl2treeloader.pas',
  knsl2uspd16401bmeter in 'knsl2uspd16401bmeter.pas',
  knsl2uspdKUB1meter in 'knsl2uspdKUB1meter.pas',
  knsl3abon in 'knsl3abon.pas' {TAbonManager},
  knsl3aboneditor in 'knsl3aboneditor.pas',
  knsl3AddrUnit in 'knsl3AddrUnit.pas',
  knsl3archive in 'knsl3archive.pas',
  knsl3calcmodule in 'knsl3calcmodule.pas',
  knsl3calcsystem in 'knsl3calcsystem.pas',
  knsl3chdteditor in 'knsl3chdteditor.pas',
  knsl3cheditor in 'knsl3cheditor.pas',
  knsl3conneditor in 'knsl3conneditor.pas',
  knsl3datafinder in 'knsl3datafinder.pas' {TDataFinder},
  knsl3dataframe in 'knsl3dataframe.pas' {DataFrame},
  knsl3datamatrix in 'knsl3datamatrix.pas',
  knsl3datatype in 'knsl3datatype.pas',
  knsl3discret in 'knsl3discret.pas',
  knsl3EventBox in 'knsl3EventBox.pas' {EventBox},
  knsl3eventsystem in 'knsl3eventsystem.pas',
  knsl3FHModule in 'knsl3FHModule.pas',
  knsl3groupeditor in 'knsl3groupeditor.pas',
  knsl3HolesFinder in 'knsl3HolesFinder.pas',
  knsl3housegen in 'knsl3housegen.pas',
  knsl3ImportAbonInfo in 'knsl3ImportAbonInfo.pas',
  knsl3indexgen in 'knsl3indexgen.pas',
  knsl3jointable in 'knsl3jointable.pas',
  knsl3LimitEditor in 'knsl3LimitEditor.pas' {fr3LimitEditor},
  knsl3lme in 'knsl3lme.pas',
  knsl3module in 'knsl3module.pas',
  knsl3Monitor in 'knsl3Monitor.pas',
  knsl3observemodule in 'knsl3observemodule.pas',
  knsl3qryschedlr in 'knsl3qryschedlr.pas',
  knsL3querysender in 'knsl3querysender.pas',
  knsl3qwerycell in 'knsl3qwerycell.pas',
  knsl3qwerytree in 'knsl3qwerytree.pas',
  knsl3recalcmodule in 'knsl3recalcmodule.pas',
  knsl3regeditor in 'knsl3regeditor.pas',
  knsl3RegionIns in 'knsl3RegionIns.pas' {Region_ES},
  knsl3report in 'knsl3report.pas' {TRepPower},
  knsl3savebase in 'knsl3savebase.pas',
  knsl3savesystem in 'knsl3savesystem.pas',
  knsl3savetime in 'knsl3savetime.pas',
  knsl3setenergo in 'knsl3setenergo.pas',
  knsl3setenergomoz in 'knsl3setenergomoz.pas',
  knsl3setgsmtime in 'knsl3setgsmtime.pas',
  knsl3szneditor in 'knsl3szneditor.pas',
  knsl3tariffeditor in 'knsl3tariffeditor.pas',
  knsl3tarplaneeditor in 'knsl3tarplaneeditor.pas',
  knsl3tartypeeditor in 'knsl3tartypeeditor.pas',
  knsl3transtime in 'knsl3transtime.pas',
  knsl3treeloader in 'knsl3treeloader.pas',
  knsl3UserControl in 'knsl3UserControl.pas',
  knsl3VectorFrame in 'knsl3vectorframe.pas' {VectorFrame},
  knsl3viewcdata in 'knsl3viewcdata.pas',
  knsl3viewgraph in 'knsl3viewgraph.pas',
  knsl3vmeter in 'knsl3vmeter.pas',
  knsl3vmetereditor in 'knsl3vmetereditor.pas',
  knsl3vparam in 'knsl3vparam.pas',
  knsl3vparameditor in 'knsl3vparameditor.pas',
  knsl3ZoneHandler in 'knsl3ZoneHandler.pas',
  knsl4a2000module in 'knsl4a2000module.pas',
  knsl4automodule in 'knsl4automodule.pas',
  knsl4btimodule in 'knsl4btimodule.pas',
  knsl4c12module in 'knsl4c12module.pas',
  knsl4cc301module in 'knsl4cc301module.pas',
  knsl4ConfMeterModule in 'knsl4ConfMeterModule.pas' {ConfMeterModule},
  knsl4connfrm in 'knsl4connfrm.pas' {ConnForm},
  knsl4connmanager in 'knsl4connmanager.pas',
  knsl4ECOMcrqsrv in 'knsl4ECOMcrqsrv.pas',
  knsl4EKOMmodule in 'knsl4EKOMmodule.pas',
  knsl4Loader in 'knsl4Loader.pas',
  knsl4module in 'knsl4module.pas',
  knsl4secman in 'knsl4secman.pas' {TUserManager},
  knsl4transit in 'knsl4transit.pas',
  knsl4Unloader in 'knsl4Unloader.pas',
  knsl5ArchBaseCopy in 'knsl5ArchBaseCopy.pas' {ArchBaseCopy},
  knsl5calendar in 'knsl5calendar.pas' {MCalendar},
  knsl5config in 'knsl5config.pas' {TL5Config},
  knsl5crypt in 'knsl5crypt.pas',
  knsl5events in 'knsl5events.pas' {TL5Events},
  knsl5FRMSQL in 'knsl5FRMSQL.pas' {FRMSQL},
  knsl5grddriver in 'knsl5grddriver.pas',
  knsl5MainEditor in 'knsl5MainEditor.pas' {frMainEditor},
  Knsl5Meter_Replace in 'Knsl5Meter_Replace.pas' {Meter_Replace},
  knsl5module in 'knsl5module.pas' {TKnsForm},
  knsl5protectmdl in 'knsl5protectmdl.pas',
  knsl5SchemEditor in 'knsl5SchemEditor.pas' {TSchemEditor},
  knsL5setcolor in 'knsL5setcolor.pas',
  knsl5tracer in 'knsl5tracer.pas',
  knsl5users in 'knsl5users.pas' {TUsers},
  knslAbout in 'knslAbout.pas' {TAbout},
  knslLoadMainForm in 'knslLoadMainForm.pas' {LoadMainForm},
  knslProgressLoad in 'knslProgressLoad.pas' {ProgressLoad},
  knslRepCorrects in 'knslRepCorrects.pas' {knslRepCorrect},
  knslRPAnalisBalansObj in 'knslRPAnalisBalansObj.pas',
  knslRPErrorMeterRegion in 'knslRPErrorMeterRegion.pas',
  knslRPErrorMeterRegionHouse in 'knslRPErrorMeterRegionHouse.pas',
  knslRPHomeBalance in 'knslRPHomeBalance.pas' {rpHomeBalanse},
  knslRPPokMeters in 'knslRPPokMeters.pas' {rpPokMeters},
  knslRPPokMetersXL in 'knslRPPokMetersXL.pas',
  knslRPRasxMonthPeriod in 'knslRPRasxMonthPeriod.pas' {RasxMonthPeriod},
  knslRPTypes in 'knslRPTypes.pas',
  OnlyOne in 'OnlyOne.pas',
  OPCDA in 'OPCDA.pas',
  OPCtypes in 'OPCtypes.pas',
  OPCutils in 'OPCutils.pas',
  RASUnit in 'RASUnit.pas',
  StrUtils in 'StrUtils.pas',
  u_Crypt in 'u_Crypt.pas',
  u_iButTMEX in 'u_iButTMEX.pas',
  uJCL in 'uJCL.pas',
  Unit1 in 'Unit1.pas' {Form1},
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4},
  utlbox in 'utlbox.pas',
  utlcbox in 'utlcbox.pas',
  utlCEmcosGenTable in 'utlCEmcosGenTable.pas',
  utlconst in 'utlconst.pas',
  utldatabase in 'utldatabase.pas',
  utlDB in 'utlDB.pas',
  utlDBForOneQuery in 'utlDBForOneQuery.pas',
  utldynconnect in 'utldynconnect.pas',
  utlexparcer in 'utlexparcer.pas',
  utlmd5 in 'utlmd5.pas',
  utlmtimer in 'utlmtimer.pas',
  utlQueryQuality in 'utlQueryQuality.pas',
  utlQueryQualityDyn in 'utlQueryQualityDyn.pas',
  utlSendRecive in 'utlSendRecive.pas',
  utlSpeedTimer in 'utlSpeedTimer.pas',
  utlStringGrid in 'utlStringGrid.pas',
  utlThread in 'utlThread.pas',
  utlTimeDate in 'utlTimeDate.pas',
  utltypes in 'utltypes.pas',
  utlverinfo in 'utlverinfo.pas',
  uTMSocket in 'uTMSocket.pas',
  VectorDiagramHelper in 'VectorDiagramHelper.pas';
  
(*  knsl5module in 'knsl5module.pas' {TKnsForm},
  utlbox in 'utlbox.pas',
  utltypes in 'utltypes.pas',
  utlconst in 'utlconst.pas',
  knsl1module in 'knsl1module.pas',
  knsl1cport in 'knsl1cport.pas',
  knsl1comport in 'knsl1comport.pas',
  utldatabase in 'utldatabase.pas',
  knsl2module in 'knsl2module.pas',
  knsl2meter in 'knsl2meter.pas',
  utlmtimer in 'utlmtimer.pas',
  knsl2ee8005meter in 'knsl2ee8005meter.pas',
  knsl2Nullmeter in 'knsl2Nullmeter.pas',
  knsl3module in 'knsl3module.pas',
  knsl3observemodule in 'knsl3observemodule.pas',
  knsL3querysender in 'knsl3querysender.pas',
  knsl4automodule in 'knsl4automodule.pas',
  knsl4a2000module in 'knsl4a2000module.pas',
  knsl4c12module in 'knsl4c12module.pas',
  knsl4btimodule in 'knsl4btimodule.pas',
  knsl4module in 'knsl4module.pas',
  knsl1editor in 'knsl1editor.pas',
  knsl4cc301module in 'knsl4cc301module.pas',
  knsl2editor in 'knsl2editor.pas',
  knsl2cmdeditor in 'knsl2cmdeditor.pas',
  knsl3groupeditor in 'knsl3groupeditor.pas',
  knsl3vmetereditor in 'knsl3vmetereditor.pas',
  knsl3vparameditor in 'knsl3vparameditor.pas',
  knsl2mtypeeditor in 'knsl2mtypeeditor.pas',
  knsl2qmcmdeditor in 'knsl2qmcmdeditor.pas',
  knsl2graphframe in 'knsl2graphframe.pas' {GraphFrame},
  knsl3vmeter in 'knsl3vmeter.pas',
  knsl3vparam in 'knsl3vparam.pas',
  knsl2treeloader in 'knsl2treeloader.pas',
  knsl2treehandler in 'knsl2treehandler.pas',
  knsl3treeloader in 'knsl3treeloader.pas',
  knsl3viewgraph in 'knsl3viewgraph.pas',
  knsl2parameditor in 'knsl2parameditor.pas',
  knsl3dataframe in 'knsl3dataframe.pas' {DataFrame},
  knsl3viewcdata in 'knsl3viewcdata.pas',
  knsl3lme in 'knsl3lme.pas',
  knsl5tracer in 'knsl5tracer.pas',
  knsl3tartypeeditor in 'knsl3tartypeeditor.pas',
  knsl3tariffeditor in 'knsl3tariffeditor.pas',
  knsl1tcp in 'knsl1tcp.pas',
  knsl3conneditor in 'knsl3conneditor.pas',
  knsl2BTIInit in 'knsl2BTIInit.pas',
  knsl4connmanager in 'knsl4connmanager.pas',
  knsl4connfrm in 'knsl4connfrm.pas' {ConnForm},
  Dates in 'Dates.pas',
  knsl3report in 'knsl3report.pas' {TRepPower},
  knsl2timers in 'knsl2timers.pas',
  knsl2BTIModule in 'knsl2BTIModule.pas',
  knsl4secman in 'knsl4secman.pas' {TUserManager},
  utlTimeDate in 'utlTimeDate.pas',
  knsl5config in 'knsl5config.pas' {TL5Config},
  u_Crypt in 'u_Crypt.pas',
  u_iButTMEX in 'u_iButTMEX.pas',
  utldynconnect in 'utldynconnect.pas',
  knsl3calcmodule in 'knsl3calcmodule.pas',
  knseditexpr in 'knseditexpr.pas' {frmEditExpr},
  utlexparcer in 'utlexparcer.pas',
  knsl5events in 'knsl5events.pas' {TL5Events},
  knsl3qryschedlr in 'knsl3qryschedlr.pas',
  knsL5setcolor in 'knsL5setcolor.pas',
  knsl5users in 'knsl5users.pas' {TUsers},
  knsl3setenergo in 'knsl3setenergo.pas',
  knsl3setgsmtime in 'knsl3setgsmtime.pas',
  RASUnit in 'RASUnit.pas',
  knsl2fmtime in 'knsl2FMTime.pas',
  knsl2ss301f3meter in 'knsl2ss301f3meter.pas',
  knslAbout in 'knslAbout.pas' {TAbout},
  knslLoadMainForm in 'knslLoadMainForm.pas' {LoadMainForm},
  knsl3recalcmodule in 'knsl3recalcmodule.pas',
  knslProgressLoad in 'knslProgressLoad.pas' {ProgressLoad},
  knsl3szneditor in 'knsl3szneditor.pas',
  knsl5calendar in 'knsl5calendar.pas' {MCalendar},
  uTMSocket in 'uTMSocket.pas',
  knsl3transtime in 'knsl3transtime.pas',
  knsl3setenergomoz in 'knsl3setenergomoz.pas',
  knsl4ConfMeterModule in 'knsl4ConfMeterModule.pas' {ConfMeterModule},
  utlverinfo in 'utlverinfo.pas',
  knsl3tarplaneeditor in 'knsl3tarplaneeditor.pas',
  knsl4EKOMmodule in 'knsl4EKOMmodule.pas',
  knsl3abon in 'knsl3abon.pas' {TAbonManager},
  knsl3aboneditor in 'knsl3aboneditor.pas',
  knsl2a2000meter in 'knsl2a2000meter.pas',
  knsl3EventBox in 'knsl3EventBox.pas' {EventBox},
  knsl3LimitEditor in 'knsl3LimitEditor.pas' {fr3LimitEditor},
  knsl3archive in 'knsl3archive.pas',
  knsl3chdteditor in 'knsl3chdteditor.pas',
  knsl3cheditor in 'knsl3cheditor.pas',
  knsl3regeditor in 'knsl3regeditor.pas',
  knsl3datafinder in 'knsl3datafinder.pas' {TDataFinder},
  knsl2C12Module in 'knsl2C12Module.pas',
  knsl5MainEditor in 'knsl5MainEditor.pas' {frMainEditor},
  knsl2EA8086Meter in 'knsl2EA8086Meter.pas',
  knsl3qwerycell in 'knsl3qwerycell.pas',
  knsl3qwerytree in 'knsl3qwerytree.pas',
  knsl3VectorFrame in 'knsl3vectorframe.pas' {VectorFrame},
  knsl4Unloader in 'knsl4Unloader.pas',
  knsl2ce6822meter in 'knsl2ce6822meter.pas',
  knsl2ce6850meter in 'knsl2ce6850meter.pas',
  knsl4Loader in 'knsl4Loader.pas',
  knsl3savetime in 'knsl3savetime.pas',
  knsl2ControlFrame in 'knsl2ControlFrame.pas' {ControlFrame},
  VectorDiagramHelper in 'VectorDiagramHelper.pas',
  knsl3discret in 'knsl3discret.pas',
  knsl3Monitor in 'knsl3Monitor.pas',
  utlSpeedTimer in 'utlSpeedTimer.pas',
  knsl2qwerymdl in 'knsl2qwerymdl.pas',
  knsl2fqwerymdl in 'knsl2fqwerymdl.pas' {TQweryModule},
  knsl2qweryvmeter in 'knsl2qweryvmeter.pas',
  knsl3jointable in 'knsl3jointable.pas',
  knsl2qwerytmr in 'knsl2qwerytmr.pas',
  knsl2qweryarchmdl in 'knsl2qweryarchmdl.pas',
  knsl2QweryTrServer in 'knsl2QweryTrServer.pas',
  knsl3HolesFinder in 'knsl3HolesFinder.pas',
  knsl3datatype in 'knsl3datatype.pas',
  knsl3datamatrix in 'knsl3datamatrix.pas',
  knsl3calcsystem in 'knsl3calcsystem.pas',
  kns3CalcTrServer in 'kns3CalcTrServer.pas',
  kns3SaveTrServer in 'kns3SaveTrServer.pas',
  knsl3savesystem in 'knsl3savesystem.pas',
  knsl2CE301BYMeter in 'knsl2CE301BYMeter.pas',
  knsl5SchemEditor in 'knsl5SchemEditor.pas' {TSchemEditor},
  knsl2qweryserver in 'knsl2qweryserver.pas',
  knsl5grddriver in 'knsl5grddriver.pas',
  knsl5protectmdl in 'knsl5protectmdl.pas',
  knsl2CE06005Meter in 'knsl2CE06005Meter.pas',
  knsl3savebase in 'knsl3savebase.pas',
  knsl3eventsystem in 'knsl3eventsystem.pas',
  knsl4ECOMcrqsrv in 'knsl4ECOMcrqsrv.pas',
  utlcbox in 'utlcbox.pas',
  knsl2cmplgrid in 'knsl2cmplgrid.pas',
  knsl3ImportAbonInfo in 'knsl3ImportAbonInfo.pas',
  utlCEmcosGenTable in 'utlCEmcosGenTable.pas',
  knsl1gprsrouter in 'knsl1gprsrouter.pas',
  knsl3AddrUnit in 'knsl3AddrUnit.pas',
  knsl5crypt in 'knsl5crypt.pas',
  knsl3UserControl in 'knsl3UserControl.pas',
  knsl3ZoneHandler in 'knsl3ZoneHandler.pas',
  knsl2uspd16401bmeter in 'knsl2uspd16401bmeter.pas',
  Desunit in 'desunit.pas',
  knsl4transit in 'knsl4transit.pas',
  knsl3FHModule in 'knsl3FHModule.pas',
  knsl3housegen in 'knsl3housegen.pas',
  knsl3indexgen in 'knsl3indexgen.pas',
  knsl2K2KBytmeter in 'knsl2K2KBytmeter.pas',
  knslRPHomeBalance in 'knslRPHomeBalance.pas' {rpHomeBalanse},
  knsl2CE102Meter in 'knsl2CE102Meter.pas',
  knsl2MIRT1Meter in 'knsl2MIRT1Meter.pas',
  knsl2CET7007Meter in 'knsl2CET7007Meter.pas',
  knsl2CE16401MMeter in 'knsl2CE16401MMeter.pas',
  utlmd5 in 'utlmd5.pas',
  knsl2MIRT1W2Meter in 'knsl2MIRT1W2Meter.pas',
  knsl2qwerybytserver in 'knsl2qwerybytserver.pas',
  knsl2qweryportpull in 'knsl2qweryportpull.pas',
  knsl2qwerybytgroup in 'knsl2qwerybytgroup.pas',
  knsl2qwerybyttmr in 'knsl2qwerybyttmr.pas',
  knsl2qwerybytcomm in 'knsl2qwerybytcomm.pas',
  StrUtils in 'StrUtils.pas',
  knsl2querybytunloader in 'knsl2querybytunloader.pas',
  knslRPErrorMeterRegion in 'knslRPErrorMeterRegion.pas',
  knslRPErrorMeterRegionHouse in 'knslRPErrorMeterRegionHouse.pas',
  knsl2SSDUBytmeter in 'knsl2SSDUBytmeter.pas',
  knsl2uspdKUB1meter in 'knsl2uspdKUB1meter.pas',
  knsl2ss101meter in 'knsl2ss101meter.pas',
  Unit1 in 'Unit1.pas' {Form1},
  knsl2CE208BYMeter in 'knsl2CE208BYMeter.pas',
  knsl2CE16401Mv4 in 'knsl2CE16401Mv4.pas',
  knsl2_HouseTask_Vzep in 'knsl2_HouseTask_Vzep.pas',
  knsl2Factory in 'knsl2Factory.pas',
  knsl2IRunnable in 'knsl2IRunnable.pas',
  knsl2CThreadPull in 'knsl2CThreadPull.pas',
  knsl2_HouseTask_SSDU in 'knsl2_HouseTask_SSDU.pas',
  knsl2_HouseTask_16401B in 'knsl2_HouseTask_16401B.pas',
  knsl2_HouseTask_16401M_K in 'knsl2_HouseTask_16401M_K.pas',
  knsl2_HouseTask_KUB in 'knsl2_HouseTask_KUB.pas',
  knsl2_HouseTask_A2000 in 'knsl2_HouseTask_A2000.pas',
  knsl2_HouseTask_Global in 'knsl2_HouseTask_Global.pas',
  knsl3RegionIns in 'knsl3RegionIns.pas' {Region_ES},
  knsl5ArchBaseCopy in 'knsl5ArchBaseCopy.pas' {ArchBaseCopy},
  utlThread in 'utlThread.pas',
  knsl2MES3meter in 'knsl2MES3meter.pas',
  fBases in 'fBases.pas' {Bases: TDataModule},
  fLogFile in 'fLogFile.pas',
  fLogTypeCommand in 'fLogTypeCommand.pas',
  fLogView in 'fLogView.pas' {LogView},
  ExeParams in 'ExeParams.pas',
  fAddUtilDBF in 'fAddUtilDBF.pas',
  OnlyOne in 'OnlyOne.pas',
  knsl5FRMSQL in 'knsl5FRMSQL.pas' {FRMSQL},
  knsl2_HouseTask_SSDU_ONE_CHANEL in 'knsl2_HouseTask_SSDU_ONE_CHANEL.pas',
  knslRPTypes in 'knslRPTypes.pas',
  uJCL in 'uJCL.pas',
  utlDB in 'utlDB.pas',
  OPCutils in 'OPCutils.pas',
  OPCDA in 'OPCDA.pas',
  OPCtypes in 'OPCtypes.pas',
  Unit4 in 'Unit4.pas' {Form4},
  Unit3 in 'Unit3.pas' {Form3},
  Knsl5Meter_Replace in 'Knsl5Meter_Replace.pas' {Meter_Replace},
  utlStringGrid in 'utlStringGrid.pas',
  knslRPPokMeters in 'knslRPPokMeters.pas' {rpPokMeters},
  knslRPAnalisBalansObj in 'knslRPAnalisBalansObj.pas',
  knslRPPokMetersXL in 'knslRPPokMetersXL.pas',
  utlQueryQuality in 'utlQueryQuality.pas',
  utlQueryQualityDyn in 'utlQueryQualityDyn.pas',
  knsl2qwerybitserver in 'knsl2qweryBITserver.pas',
  frmTreeDataModule in 'frmTreeDataModule.pas' {frameTreeDataModule: TFrame},
  knsl2_USPD1500 in 'knsl2_USPD1500.pas',
  knsl2_HouseTask_USPD1500 in 'knsl2_HouseTask_USPD1500.pas',
  frmQueryModule in 'frmQueryModule.pas' {FrameQueryModule: TFrame},
  utlSendRecive in 'utlSendRecive.pas',
  frmRepCorrect in 'frmRepCorrect.pas' {fRepCorrect: TFrame},
  knslRepCorrects in 'knslRepCorrects.pas' {knslRepCorrect},
  knslRPRasxMonthPeriod in 'knslRPRasxMonthPeriod.pas' {RasxMonthPeriod},
  frmFETWPanel in 'frmFETWPanel.pas' {frameFETW: TFrame},
  frmEditTreeView in 'frmEditTreeView.pas' {FrameEditTreeView: TFrame},
  formEditTreeView in 'formEditTreeView.pas' {FEditTreeView},
  utlDBForOneQuery in 'utlDBForOneQuery.pas'; *)

{$R *.RES}
var wnd         : HWND;
    LE          : DWORD;      //�������� ������ ������ ���������� knslmodule
    Fl          : TINIFile;
    m_nOOOA     : integer;
begin
  Fl := TINIFile.Create(ExtractFilePath(Application.ExeName) + '\\Settings\\USPD_Config.ini');
  m_nOOOA := Fl.ReadInteger('DBCONFIG','m_nOpenOnlyOneApp', -1);
  Fl.Destroy;
  CreateMutex(nil, false, PChar('{92CEEB41-1CCD-477B-8A34-AA0358992A59}'));
  if (m_nOOOA >= 1) then
  begin
    LE := GetLastError();
    if (LE = ERROR_ALREADY_EXISTS) or (LE = ERROR_ACCESS_DENIED) then
    begin
      wnd := FindWindow(LPCTSTR('TTKnsForm'), nil);
      if wnd <> 0 then
        SendMessage(wnd,WM_GOTOFOREGROUND, 0, 0);
      Application.Terminate;
      Exit;
    end;
  end;
  Application.Initialize;
  Application.CreateForm(TTKnsForm, TKnsForm);
  Application.CreateForm(TTAbonManager, TAbonManager);
  Application.CreateForm(TLogView, LogView);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TArchBaseCopy, ArchBaseCopy);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TFRMSQL, FRMSQL);
  Application.CreateForm(TTUsers, TUsers);
  Application.CreateForm(TrpHomeBalanse, rpHomeBalanse);
  Application.CreateForm(TfrMainEditor, frMainEditor);
  Application.CreateForm(TMeter_Replace, Meter_Replace);
  Application.CreateForm(TRegion_ES, Region_ES);
  Application.CreateForm(TrpPokMeters, rpPokMeters);
  Application.CreateForm(TknslRepCorrect, knslRepCorrect);
  Application.CreateForm(TRasxMonthPeriod, RasxMonthPeriod);
  Application.CreateForm(TFEditTreeView, FEditTreeView);
  Application.Run;
end.
