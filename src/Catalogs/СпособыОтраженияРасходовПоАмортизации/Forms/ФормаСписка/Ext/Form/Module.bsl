﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОсновнаяОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	ПустаяОрганизация	= Справочники.Организации.ПустаяСсылка();
	
	Если ОсновнаяОрганизация <> ПустаяОрганизация Тогда 
		МассивОтбора = Новый Массив;
		МассивОтбора.Добавить(ОсновнаяОрганизация);
		МассивОтбора.Добавить(ПустаяОрганизация);
		
		ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма, , , МассивОтбора);
	КонецЕсли;
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.СпособыОтраженияРасходовПоАмортизации);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		
		МассивОтбора = Новый Массив;
				
		ПустаяОрганизация = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка");
		
		МассивОтбора.Добавить(Параметр);
		МассивОтбора.Добавить(ПустаяОрганизация);

		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, , МассивОтбора);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

#КонецОбласти
