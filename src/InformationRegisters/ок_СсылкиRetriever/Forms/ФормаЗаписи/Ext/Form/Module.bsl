﻿
&НаКлиенте
Процедура СсылкаRetrieverНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СтрДлина(Запись.СсылкаRetriever) > 0 Тогда 
	
		ЗапуститьПриложение(Запись.СсылкаRetriever);
	
	КонецЕсли;
	
КонецПроцедуры
