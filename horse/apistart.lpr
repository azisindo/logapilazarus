program apistart;

//{$mode objfpc}{$H+}
{$MODE DELPHI}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes ,
  Horse,
  Horse.Logger, // It's necessary to use the unit
  Horse.Logger.Provider.Console, //log console
  Horse.Logger.Provider.LogFile, //log file
  SysUtils
  { you can add units after this };

var
  LLogFileConfig: THorseLoggerLogFileConfig;





procedure GetPing(Req: THorseRequest; Res: THorseResponse);
begin
  Res.Send('Bismillah Test API 2 , Alhamduilillah Sukses Aamiin');
end;

begin

   //DEFAULT_HORSE_LOG_FORMAT =
   // '${request_clientip} [${time}] ${request_user_agent}' +
   // ' "${request_method} ${request_path_info} ${request_version}"' +
   // ' ${response_status} ${response_content_length}';

  //Start Log file
  LLogFileConfig := THorseLoggerLogFileConfig.New
     .SetLogFormat('${request_clientip} [${time}] ${response_status} ${request_method} ${request_path_info}')
     .SetDir('/home/developer/app/mvc/app/api');

  THorseLoggerManager.RegisterProvider(THorseLoggerProviderLogFile.New(LLogFileConfig));

  THorseLoggerManager.RegisterProvider(THorseLoggerProviderLogFile.New());
  //end log file

  //start log console
  THorseLoggerManager.RegisterProvider(THorseLoggerProviderConsole.New());
  //end log console


  THorse.Use(THorseLoggerManager.HorseCallback);

  THorse.Get('/ping', GetPing);

  THorse.Listen(9000);
end.
