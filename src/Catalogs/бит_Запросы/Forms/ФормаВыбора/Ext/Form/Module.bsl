﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Метаданные.Справочники.бит_Запросы;
	
	// Вызов механизма защиты
	 	
	
	бит_РаботаСДиалогамиСервер.ФормаВыбораПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);

	Если фОтказ Тогда
		Возврат;
	КонецЕсли;
	
	// Автоматические REST сервисы доступны только начиная с версии 8.3.5.1.
	ТекВерсияПлатформы = бит_ОбщегоНазначенияКлиентСервер.ВерсияПлатформы();
	КонтрольнаяВерсия = "8.3.5.1";
	
	фВерсияСтарше835 = бит_ОбщегоНазначенияКлиентСервер.ВерсияОбновленияСтарше(КонтрольнаяВерсия, ТекВерсияПлатформы);
	Элементы.Вид.Видимость = фВерсияСтарше835;	
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если фОтказ Тогда
		Отказ = Истина;
		Возврат;	
	КонецЕсли;
	
КонецПроцедуры // ПриОткрытии()

#КонецОбласти

