﻿
&НаКлиенте
Процедура ОК(Команда)
	СтруктураПараметров = Новый Структура("ПользовательSMTP, ПарольSMTP", ПользовательSMTP, ПарольSMTP);
	Закрыть(СтруктураПараметров);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПарольПриИзменении(Элемент)
	
	Если ПоказатьПароль = Истина Тогда 
		Элементы.ПарольSMTP.РежимПароля = Ложь;
	Иначе 
		Элементы.ПарольSMTP.РежимПароля = Истина;
	КонецЕсли;

	ПарольSMTP = Неопределено;	
	
	ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПоказатьПароль = Ложь;
КонецПроцедуры

