set "streaming.storm.submit.islocal" = "true";
set "streaming.localtask.alivetime.ms" = "500";
set "operator.kafka.brokers"="192.168.0.2:9092";
set "serde.simpleserde.separator" = ",";
create input stream S 
(id int,name String,type int)
	 SERDE SimpleSerDe
	 SOURCE 'com.huawei.streaming.operator.inputstream.HeadStreamSourceOp'
		 PROPERTIES ("operator.headstream.timeunit" = "SECONDS",
						"operator.headstream.period"="1",
						"operator.headstream.eventnumperperiod"="1000",
						"operator.headstream.isschedule"="true",
						"operator.headstream.totalnumber"="10000",
						"operator.headstream.delaytime"="3");
							
create output stream rs 
	(id string,name string,cc int)
	 SERDE SimpleSerDe
  SINK 'com.huawei.streaming.operator.outputstream.ConsolePrintOp';
	
	--filter before window selft join			
insert into stream rs select s.id,s.name,s2.type from S[range today type] join S(s2.id>10)[range unbounded] as s2 unidirection on s.id = s2.id where s.id > 5;
explain application simple;