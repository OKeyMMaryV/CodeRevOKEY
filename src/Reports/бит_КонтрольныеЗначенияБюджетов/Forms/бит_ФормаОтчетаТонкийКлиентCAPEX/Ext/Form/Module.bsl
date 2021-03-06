

//////////////////////////////////////////////////////////////////////////////
//// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
            
// бит_ASubbotina Процедура - обработчик события "ПриОткрытии" формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если фОтказ Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	мСоответствиеРезультатов = Новый Соответствие;
	
	// BIT AMerkulov 29052014 	
	ПриОткрытииНаСервере();	
	//Элементы.ГруппаПанельВыбораСохраненныхНастроек.Видимость = Ложь;
	//Элементы.ГруппаКоманднаяПанельОтчета.ТолькоПросмотр = Истина;
	//Элементы.ГруппаПанельНастроек.Видимость = Ложь;
	// }	
	
КонецПроцедуры // ПриОткрытии()

// BIT AMerkulov 29052014 {
&НаСервере
Процедура ПриОткрытииНаСервере()	
	МакетCAPEX = Отчеты.бит_КонтрольныеЗначенияБюджетов.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных"+ Отчет.бит_ВидЗаявки);
	Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(МакетCAPEX.НастройкиПоУмолчанию);
КонецПроцедуры	
// }

&НаКлиенте
Процедура УстановитьПараметры(СписокОбъектов)  Экспорт

	УстановитьПараметрыНаСервере(СписокОбъектов);
	СкомпоноватьРезультат();

КонецПроцедуры


&НаСервере
Процедура УстановитьПараметрыНаСервере(СписокОбъектов)  Экспорт
	
	ЭлементОтбора = Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Аналитика_2");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	ЭлементОтбора.ПравоеЗначение = СписокОбъектов;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	   ВариантМодифицирован = Ложь;
КонецПроцедуры



