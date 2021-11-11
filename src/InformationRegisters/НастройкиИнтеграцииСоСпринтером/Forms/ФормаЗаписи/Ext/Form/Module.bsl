﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Параметры, "ОрганизацияСсылка") И ЗначениеЗаполнено(Параметры.ОрганизацияСсылка) Тогда
		ЗаписьПоОрганизации = РегистрыСведений.НастройкиИнтеграцииСоСпринтером.СоздатьМенеджерЗаписи();
		ЗаписьПоОрганизации.Организация = Параметры.ОрганизацияСсылка;
		ЗаписьПоОрганизации.Прочитать();
		
		Если ЗначениеЗаполнено(ЗаписьПоОрганизации.Организация) Тогда
			ЗначениеВДанныеФормы(ЗаписьПоОрганизации, Запись);	
		Иначе
			Запись.Организация = Параметры.ОрганизацияСсылка;		
		КонецЕсли;
		
	Иначе
		Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
			ЗаписьПоОрганизации = РегистрыСведений.НастройкиИнтеграцииСоСпринтером.СоздатьМенеджерЗаписи();
			
			Модуль = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
			ЗаписьПоОрганизации.Организация = Модуль.ОрганизацияПоУмолчанию();
			
			ЗаписьПоОрганизации.Прочитать();
			
			Если ЗначениеЗаполнено(ЗаписьПоОрганизации.Организация) Тогда
				ЗначениеВДанныеФормы(ЗаписьПоОрганизации, Запись);	
			Иначе
				Запись.Организация = Модуль.ОрганизацияПоУмолчанию();		
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если НЕ ПроверитьЗаполнениеПараметров() Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КаталогПрограммыЭлектроннойПочтыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КаталогПрограммыЭлектроннойПочтыНачалоВыбораЗавершение", ЭтотОбъект);
	ТекстСообщения = ОперацииСФайламиЭДКОКлиент.ТекстСообщенияДляНеобязательнойУстановкиРасширенияРаботыСФайлами();;
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(ОписаниеОповещения, ТекстСообщения, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогОтправкиДанныхОтчетностиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КаталогОтправкиДанныхОтчетностиНачалоВыбораЗавершение", ЭтотОбъект);
	ТекстСообщения = ОперацииСФайламиЭДКОКлиент.ТекстСообщенияДляНеобязательнойУстановкиРасширенияРаботыСФайлами();;
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(ОписаниеОповещения, ТекстСообщения, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогПрограммыЭлектроннойПочтыОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КаталогПрограммыЭлектроннойПочтыОткрытиеЗавершение", ЭтотОбъект);
	ТекстСообщения = ОперацииСФайламиЭДКОКлиент.ТекстСообщенияДляНеобязательнойУстановкиРасширенияРаботыСФайлами();;
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(ОписаниеОповещения, ТекстСообщения, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогОтправкиДанныхОтчетностиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КаталогОтправкиДанныхОтчетностиОткрытиеЗавершение", ЭтотОбъект);
	ТекстСообщения = ОперацииСФайламиЭДКОКлиент.ТекстСообщенияДляНеобязательнойУстановкиРасширенияРаботыСФайлами();;
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(ОписаниеОповещения, ТекстСообщения, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПроверитьЗаполнениеПараметров()
	
	Если НЕ ЗначениеЗаполнено(Запись.Организация) Тогда
		ПоказатьПредупреждение(, "Не выбрана организация!");
		Возврат Ложь;
	КонецЕсли;
	
	Если СтрДлина(СокрЛП(Запись.КодАбонента)) <> 7 Тогда
		ПоказатьПредупреждение(, "Недопустимый логин!");
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Запись.КаталогПрограммыЭлектроннойПочты) Тогда
		ПоказатьПредупреждение(, "Не указан каталог программы электронной почты!");
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Запись.КаталогОтправкиДанныхОтчетности) Тогда
		ПоказатьПредупреждение(, "Не выбрана каталог отправки данных отчетности!");
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура КаталогПрограммыЭлектроннойПочтыНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
	
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		ДиалогОткрытияФайла.Каталог = Запись.КаталогПрограммыЭлектроннойПочты;
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите путь к каталогу программы электронной почты'");
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"КаталогПрограммыЭлектроннойПочтыНачалоВыбораПослеПоказаДиалогаВыбораФайла", 
			ЭтотОбъект);
		
		ДиалогОткрытияФайла.Показать(ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогПрограммыЭлектроннойПочтыНачалоВыбораПослеПоказаДиалогаВыбораФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() > 0 Тогда
		
		Каталог = ВыбранныеФайлы[0] + ПолучитьРазделительПути();
		Запись.КаталогПрограммыЭлектроннойПочты = Каталог;
		
		Если СтрДлина(СокрЛП(Запись.КодАбонента)) = 7 Тогда
			
			ПредполагаемыйКаталогОтправкиДанныхОтчетности = 
				Запись.КаталогПрограммыЭлектроннойПочты
				+ "EXPT" 
				+ Лев(Запись.КодАбонента, 4) 
				+ "." 
				+ Прав(Запись.КодАбонента, 3) 
				+ ПолучитьРазделительПути();
				
			ДополнительныеПараметры = Новый Структура();
			ДополнительныеПараметры.Вставить("ПредполагаемыйКаталогОтправкиДанныхОтчетности", ПредполагаемыйКаталогОтправкиДанныхОтчетности);
			
			ОписаниеОповещения = Новый ОписаниеОповещения(
				"КаталогПрограммыЭлектроннойПочтыНачалоВыбораПослеПроверкиСуществованияФайла", 
				ЭтотОбъект, 
				ДополнительныеПараметры);
				
			ОперацииСФайламиЭДКОКлиент.ПолучитьСвойстваФайла(
				ОписаниеОповещения, 
				ПредполагаемыйКаталогОтправкиДанныхОтчетности);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогПрограммыЭлектроннойПочтыНачалоВыбораПослеПроверкиСуществованияФайла(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Выполнено И Результат.СвойстваФайла.Существует Тогда
		
		Запись.КаталогОтправкиДанныхОтчетности = ДополнительныеПараметры.ПредполагаемыйКаталогОтправкиДанныхОтчетности;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогОтправкиДанныхОтчетностиНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	ДиалогОткрытияФайла.Каталог = Запись.КаталогПрограммыЭлектроннойПочты;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите путь к каталогу отправки данных отчетности'");
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"КаталогОтправкиДанныхОтчетностиНачалоВыбораПослеВыбораКаталога", 
		ЭтотОбъект);
	
	ДиалогОткрытияФайла.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогОтправкиДанныхОтчетностиНачалоВыбораПослеВыбораКаталога(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() > 0 Тогда
		Запись.КаталогОтправкиДанныхОтчетности = ВыбранныеФайлы[0] + ПолучитьРазделительПути();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогПрограммыЭлектроннойПочтыОткрытиеЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	ОперацииСФайламиЭДКОКлиент.ОткрытьФайл(Запись.КаталогПрограммыЭлектроннойПочты);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогОтправкиДанныхОтчетностиОткрытиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОперацииСФайламиЭДКОКлиент.ОткрытьФайл(Запись.КаталогОтправкиДанныхОтчетности);
	
КонецПроцедуры

#КонецОбласти