﻿////////////////////////////////////////////////////////////////////////////////
// КЛИЕНТСКИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область КлиентскиеПроцедурыИФункции




#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

#Область ПроцедурыИФункцииОбщегоНазначения



// Процедура устанавливает отбор в списке файлов.
// 
// Параметры:
//  Нет.
// 
&НаКлиенте
Процедура УстановитьОтборВСпискеФайлов()
	
	// Установим отбор в списке файлов по объекту файлов.
	бит_ОбщегоНазначенияКлиентСервер.УстановитьОтборУСписка(СписокФайлов.Отбор
														   ,Новый ПолеКомпоновкиДанных("Объект")
														   ,Объект.Объект);
	
КонецПроцедуры // УстановитьОтборВСпискеФайлов()


#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ.

#Область ПроцедурыИФункцииДляУправленияВнешнимВидомФормы



// Процедура осуществляет управление доступностью/видимостью элементов формы.
// 
// Параметры:
//  Нет.
// 
&НаКлиенте
Процедура УправлениеЭлементамиФормы()
	
	Элементы.Объект.Видимость 	   = ПоказыватьОбъект;
	Элементы.ГруппаФайлы.Видимость = бит_ХранениеДополнительнойИнформации.МеханизмХраненияДополнительнойИнформацииЕсть();
	
КонецПроцедуры // УправлениеЭлементамиФормы()


#КонецОбласти

////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

#Область ПроцедурыОбработчикиСобытийФормы



// Процедура - обработчик события "ПриОткрытии" формы.
// 
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если фОтказ Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УстановитьОтборВСпискеФайлов();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры


#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

#Область ОбработчикиКомандФормы



// Процедура - обработчик команды "ОткрытьФайл" формы.
// 
&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	ДанныеТекущейСтроки = Элементы.СписокФайлов.ТекущиеДанные;
	
	Если ДанныеТекущейСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрокаСсылка = Элементы.СписокФайлов.ТекущаяСтрока;
	
	бит_ХранениеДополнительнойИнформацииКлиент.ОткрытьФайл(ТекущаяСтрокаСсылка, ДанныеТекущейСтроки.ИмяФайла);
	
КонецПроцедуры

// Процедура - обработчик команды "СохранитьФайл" формы.
// 
&НаКлиенте
Процедура СохранитьФайл(Команда)
	
	ДанныеТекущейСтроки = Элементы.СписокФайлов.ТекущиеДанные;
	
	Если ДанныеТекущейСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрокаСсылка = Элементы.СписокФайлов.ТекущаяСтрока;
	
	бит_ХранениеДополнительнойИнформацииКлиент.СохранитьФайл(ТекущаяСтрокаСсылка, ДанныеТекущейСтроки.ИмяФайла);
	
КонецПроцедуры


#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ.

#Область ПроцедурыОбработчикиСобытийЭлементовФормы



// Процедура - обработчик события "ПриИзменении" поля ввода "Объект".
// 
&НаКлиенте
Процедура ОбъектПриИзменении(Элемент)
	
	УстановитьОтборВСпискеФайлов();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры


#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ "СписокФайлов".

#Область ПроцедурыОбработчикиСобытийТабличногоПоляСписокфайлов



// Процедура - обработчик события "ПередНачаломДобавления" 
// табличного поля "СписокФайлов".
// 
&НаКлиенте
Процедура СписокФайловПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ФормаДляОткрытия = ПолучитьФорму("Справочник.бит_ХранилищеДополнительнойИнформации.Форма.ФормаЭлементаУправляемая",, ЭтаФорма);
	ФормаДляОткрытия.Объект.Объект = Объект.Объект;
	ФормаДляОткрытия.Открыть();
		
КонецПроцедуры



#КонецОбласти

#Область ОбработчикиСобытийФормы

// Процедура - обработчик события "ПриОткрытии" формы.
// 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);

	МетаданныеОбъекта = Метаданные.Обработки.бит_ПрикреплениеФайлов;
	
	// Вызов механизма защиты
	
	
	Если фОтказ Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Объект", Объект.Объект);
	
    ПоказыватьОбъект = ?(Параметры.Свойство("ПоказыватьОбъект"), Параметры.ПоказыватьОбъект, Истина);
	
КонецПроцедуры

#КонецОбласти

