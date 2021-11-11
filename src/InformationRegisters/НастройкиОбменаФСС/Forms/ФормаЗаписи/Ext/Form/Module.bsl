﻿&НаКлиенте
Перем КонтекстЭДО;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ОрганизацияСсылка) Тогда
		
		ЗаписьПоОрганизации = РегистрыСведений.НастройкиОбменаФСС.СоздатьМенеджерЗаписи();
		ЗаписьПоОрганизации.Организация = Параметры.ОрганизацияСсылка;
		ЗаписьПоОрганизации.Пользователь = Справочники.Пользователи.ПустаяСсылка();
		ЗаписьПоОрганизации.Прочитать();
		
		Если ЗначениеЗаполнено(ЗаписьПоОрганизации.Организация) Тогда
			ЗначениеВДанныеФормы(ЗаписьПоОрганизации, Запись);
		Иначе
			Запись.Организация = Параметры.ОрганизацияСсылка;
		КонецЕсли;
		
	КонецЕсли;
	
	ЭтоЭлектроннаяПодписьВМоделиСервиса =
		ЭлектроннаяПодписьВМоделиСервисаБРОВызовСервера.ЭтоЭлектроннаяПодписьВМоделиСервиса(Запись.Организация);
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.СкрытьЭлементыФормыПриИспользованииОднойОрганизации(
		ЭтаФорма, "НадписьОрганизация");
	ЭтоПолноправныйПользователь = НЕ ОбщегоНазначения.РазделениеВключено() И Пользователи.ЭтоПолноправныйПользователь();
	ИспользоватьНесколькоСохраненное = (Запись.ИспользоватьНесколько = Истина);
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	СвойстваОрганизацииИУчетнойЗаписи = Неопределено;
	Если КонтекстЭДОСервер <> Неопределено Тогда
		СвойстваОрганизацииИУчетнойЗаписи = КонтекстЭДОСервер.ЕстьВозможностьАвтонастройкиВУниверсальномФормате(
			Запись.Организация, Истина);
	КонецЕсли;
	
	СертификатыСтрахователейПользователей = СписокПользователейИСертификатовСтрахователей(Запись.Организация);
	Элементы.ИспользоватьНесколько.Видимость = СертификатыСтрахователейПользователей.Количество() > 1
		ИЛИ (Запись.ИспользоватьНесколько = Истина);
	
	Элементы.ГруппаАвтонастройка.Видимость =
		(СвойстваОрганизацииИУчетнойЗаписи <> Неопределено
		И СвойстваОрганизацииИУчетнойЗаписи.ЕстьВозможностьАвтонастройкиВУниверсальномФормате);
	Элементы.ГруппаИнформация1СОтчетностьНеИспользуется.Видимость =
		(СвойстваОрганизацииИУчетнойЗаписи = Неопределено
		ИЛИ СвойстваОрганизацииИУчетнойЗаписи.ВидОбменаСКонтролирующимиОрганами <>
			ПредопределенноеЗначение("Перечисление.ВидыОбменаСКонтролирующимиОрганами.ОбменВУниверсальномФормате")
		ИЛИ НЕ ЗначениеЗаполнено(СвойстваОрганизацииИУчетнойЗаписи.УчетнаяЗаписьОбмена));
	
	КлючСохраненияПоложенияОкна = "НастройкиФСС" + ?(Элементы.ГруппаАвтонастройка.Видимость, "Автонастройка", "")
		+ ?(Элементы.ГруппаИнформация1СОтчетностьНеИспользуется.Видимость, "Подключение", "");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
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
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзменениеНастроекЭДООрганизации", Запись.Организация);
	
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
Процедура ИспользоватьНесколькоПриИзменении(Элемент)
	
	ОтобразитьСертификатСтрахователя(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатСтрахователяПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Запись.ИспользоватьНесколько = Истина Тогда
		ВыбратьНесколькоСертификатовСтрахователя();
		
	Иначе
		Оповещение = Новый ОписаниеОповещения(
			"СертификатСтрахователяПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));
		
		КриптографияЭДКОКлиент.ВыбратьСертификат(
			Оповещение, ЭтоЭлектроннаяПодписьВМоделиСервиса, Запись.СертификатСтрахователяОтпечаток, "My");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения(
		"СертификатФССПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));
	
	КриптографияЭДКОКлиент.ВыбратьСертификат(
		Оповещение, ЭтоЭлектроннаяПодписьВМоделиСервиса, Запись.СертификатФССОтпечаток, "AddressBook");
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССЭЛНПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения(
		"СертификатФССЭЛНПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));
	
	КриптографияЭДКОКлиент.ВыбратьСертификат(
		Оповещение, ЭтоЭлектроннаяПодписьВМоделиСервиса, Запись.СертификатФССЭЛНОтпечаток, "AddressBook");
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОбменПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатСтрахователяПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Запись.ИспользоватьНесколько = Истина Тогда
		ТекущийПользователь = ПользователиКлиент.ТекущийПользователь();
		СертификатСтрахователяПользователя = СертификатыСтрахователейПользователей.НайтиПоЗначению(ТекущийПользователь);
		ОтпечатокСертификатаСтрахователя = ?(СертификатСтрахователяПользователя = Неопределено,
			"", СертификатСтрахователяПользователя.Представление);
	Иначе
		ОтпечатокСертификатаСтрахователя = Запись.СертификатСтрахователяОтпечаток;
	КонецЕсли;
	
	Если Запись.ИспользоватьНесколько = Истина И ЗначениеЗаполнено(СертификатСтрахователяПредставление)
		И НЕ ЗначениеЗаполнено(ОтпечатокСертификатаСтрахователя) Тогда
		
		ВыбратьНесколькоСертификатовСтрахователя();
		
	ИначеЕсли ЗначениеЗаполнено(ОтпечатокСертификатаСтрахователя) Тогда
		КриптографияЭДКОКлиент.ПоказатьСертификат(
			Новый Структура("Отпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса",
			ОтпечатокСертификатаСтрахователя, ЭтоЭлектроннаяПодписьВМоделиСервиса));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КриптографияЭДКОКлиент.ПоказатьСертификат(
		Новый Структура("Отпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса",
		Запись.СертификатФССОтпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса));
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССЭЛНПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КриптографияЭДКОКлиент.ПоказатьСертификат(
		Новый Структура("Отпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса",
		Запись.СертификатФССЭЛНОтпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса));
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатСтрахователяПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ Запись.ИспользоватьНесколько = Истина Тогда
		Запись.СертификатСтрахователяОтпечаток = "";
		СертификатСтрахователяПредставление = "";
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса,
			Элемент,
			Запись.СертификатСтрахователяОтпечаток,
			ЭтотОбъект,
			"СертификатСтрахователяПредставление");
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Запись.СертификатФССОтпечаток = "";
	СертификатФССПредставление = "";
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		ЭтоЭлектроннаяПодписьВМоделиСервиса,
		Элемент,
		Запись.СертификатФССОтпечаток,
		ЭтотОбъект,
		"СертификатФССПредставление");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССЭЛНПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Запись.СертификатФССЭЛНОтпечаток = "";
	СертификатФССЭЛНПредставление = "";
	Запись.ТестовыйСерверФССЭЛН = Ложь;
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		ЭтоЭлектроннаяПодписьВМоделиСервиса,
		Элемент,
		Запись.СертификатФССЭЛНОтпечаток,
		ЭтотОбъект,
		"СертификатФССЭЛНПредставление");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
	ОтобразитьСертификатСтрахователя();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьсяК1СОтчетности(Команда)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьФормуМастераЗаявленияНаПодключение(Запись.Организация, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДО = Результат.КонтекстЭДО;
	
	ОбновитьДоступностьЭлементов();
	
	КонтекстЭДО.УправлениеОтображениемОрганизации(ЭтаФорма, Запись.Организация);
	
	Если Запись.ИспользоватьНесколько = Истина Тогда
		ТекущийПользователь = ПользователиКлиент.ТекущийПользователь();
		СертификатСтрахователяПользователя = СертификатыСтрахователейПользователей.НайтиПоЗначению(ТекущийПользователь);
		ОтпечатокСертификатаСтрахователя = ?(СертификатСтрахователяПользователя = Неопределено,
			"", СертификатСтрахователяПользователя.Представление);
	Иначе
		ОтпечатокСертификатаСтрахователя = Запись.СертификатСтрахователяОтпечаток;
	КонецЕсли;
	
	ПараметрыОтображенияСертификатов = Новый Массив;
	
	ПараметрыОтображенияСертификата = Новый Структура;
	ПараметрыОтображенияСертификата.Вставить("ПолеВвода", 								Элементы.СертификатСтрахователяПредставление);
	ПараметрыОтображенияСертификата.Вставить("Сертификат", 								ОтпечатокСертификатаСтрахователя);
	ПараметрыОтображенияСертификата.Вставить("ИмяРеквизитаПредставлениеСертификата", 	"СертификатСтрахователяПредставление");
	
	ПараметрыОтображенияСертификатов.Добавить(ПараметрыОтображенияСертификата);
	
	ПараметрыОтображенияСертификата = Новый Структура;
	ПараметрыОтображенияСертификата.Вставить("ПолеВвода", 								Элементы.СертификатФССПредставление);
	ПараметрыОтображенияСертификата.Вставить("Сертификат", 								Запись.СертификатФССОтпечаток);
	ПараметрыОтображенияСертификата.Вставить("ИмяРеквизитаПредставлениеСертификата", 	"СертификатФССПредставление");
	
	ПараметрыОтображенияСертификатов.Добавить(ПараметрыОтображенияСертификата);
	
	ПараметрыОтображенияСертификата = Новый Структура;
	ПараметрыОтображенияСертификата.Вставить("ПолеВвода", 								Элементы.СертификатФССЭЛНПредставление);
	ПараметрыОтображенияСертификата.Вставить("Сертификат", 								Запись.СертификатФССЭЛНОтпечаток);
	ПараметрыОтображенияСертификата.Вставить("ИмяРеквизитаПредставлениеСертификата", 	"СертификатФССЭЛНПредставление");
	
	ПараметрыОтображенияСертификатов.Добавить(ПараметрыОтображенияСертификата);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииПослеОтображенияСертификатов", ЭтотОбъект);
	КриптографияЭДКОКлиент.ОтобразитьПредставленияСертификатов(
		ПараметрыОтображенияСертификатов,
		ЭтотОбъект,
		ЭтоЭлектроннаяПодписьВМоделиСервиса,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииПослеОтображенияСертификатов(Результат, ДополнительныеПараметры) Экспорт
	
	СкорректироватьПредставлениеСертификатаСтрахователя();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьНесколькоСертификатовСтрахователя(УстановленоИспользоватьНесколько = Ложь)
	
	Если Модифицированность И НЕ Записать() Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("УстановленоИспользоватьНесколько", УстановленоИспользоватьНесколько);
	Оповещение = Новый ОписаниеОповещения("ВыбратьНесколькоСертификатовСтрахователяПослеВыбора",
		ЭтотОбъект, ДополнительныеПараметры);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ОрганизацияСсылка", 					Запись.Организация);
	СтруктураПараметров.Вставить("УстановленоИспользоватьНесколько", 	УстановленоИспользоватьНесколько);
	
	ОткрытьФорму(
		"РегистрСведений.НастройкиОбменаФСС.Форма.ФормаСпискаПоПользователям",
		СтруктураПараметров,
		ЭтотОбъект,,,,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьНесколькоСертификатовСтрахователяПослеВыбора(Результат, ВходящийКонтекст) Экспорт
	
	УстановленоИспользоватьНесколько = ВходящийКонтекст.УстановленоИспользоватьНесколько;
	
	Если Результат <> КодВозвратаДиалога.ОК Тогда
		Если УстановленоИспользоватьНесколько Тогда
			Запись.ИспользоватьНесколько = Ложь;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	СертификатыСтрахователейПользователей = СписокПользователейИСертификатовСтрахователей(Запись.Организация);
	Элементы.ИспользоватьНесколько.Видимость = СертификатыСтрахователейПользователей.Количество() > 1
		ИЛИ Запись.ИспользоватьНесколько = Истина;
	
	ЗаписьПоОрганизации = НастройкиОбменаФССОрганизации(Запись.Организация);
	
	Если (ЗаписьПоОрганизации.ИспользоватьНесколько = Истина) <> (Запись.ИспользоватьНесколько = Истина) Тогда
		Запись.ИспользоватьНесколько = (ЗаписьПоОрганизации.ИспользоватьНесколько = Истина);
	КонецЕсли;
	
	Если ЗаписьПоОрганизации.СертификатСтрахователяОтпечаток <> Запись.СертификатСтрахователяОтпечаток Тогда
		Запись.СертификатСтрахователяОтпечаток = ЗаписьПоОрганизации.СертификатСтрахователяОтпечаток;
	КонецЕсли;
	
	Если Запись.ИспользоватьНесколько = Истина Тогда
		ТекущийПользователь = ПользователиКлиент.ТекущийПользователь();
		СертификатСтрахователяПользователя = СертификатыСтрахователейПользователей.НайтиПоЗначению(ТекущийПользователь);
		ОтпечатокСертификатаСтрахователя = ?(СертификатСтрахователяПользователя = Неопределено,
			"", СертификатСтрахователяПользователя.Представление);
	Иначе
		ОтпечатокСертификатаСтрахователя = Запись.СертификатСтрахователяОтпечаток;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьНесколькоСертификатовСтрахователяПослеОтображения", ЭтотОбъект);
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		ЭтоЭлектроннаяПодписьВМоделиСервиса,
		Элементы.СертификатСтрахователяПредставление,
		ОтпечатокСертификатаСтрахователя,
		ЭтотОбъект,
		"СертификатСтрахователяПредставление",
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьНесколькоСертификатовСтрахователяПослеОтображения(Результат, ВходящийКонтекст) Экспорт
	
	СкорректироватьПредставлениеСертификатаСтрахователя();
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатСтрахователяПредставлениеНачалоВыбораЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	Элемент = ВходящийКонтекст.Элемент;
	
	Если Результат.Выполнено Тогда
		Запись.СертификатСтрахователяОтпечаток = Результат.ВыбранноеЗначение.Отпечаток;
		
		ВыбранныйСертификатСтрахователя = Результат.ВыбранноеЗначение;
		Если ЭтоЭлектроннаяПодписьВМоделиСервиса Тогда
			ВыбранныйСертификатСтрахователя = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(
				ВыбранныйСертификатСтрахователя, Ложь);
			ВыбранныйСертификатСтрахователя.Вставить("ЭтоЭлектроннаяПодписьВМоделиСервиса",
				ЭтоЭлектроннаяПодписьВМоделиСервиса);
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("СертификатСтрахователя", 				ВыбранныйСертификатСтрахователя);
		ДополнительныеПараметры.Вставить("ЭтоЭлектроннаяПодписьВМоделиСервиса", ЭтоЭлектроннаяПодписьВМоделиСервиса);
		Оповещение = Новый ОписаниеОповещения("СертификатСтрахователяПредставлениеНачалоВыбораПослеОтображения",
			ЭтотОбъект, ДополнительныеПараметры);
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса,
			Элемент, 
			Результат.ВыбранноеЗначение.Отпечаток, 
			ЭтотОбъект,
			"СертификатСтрахователяПредставление",
			Оповещение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатСтрахователяПредставлениеНачалоВыбораПослеОтображения(Результат, ВходящийКонтекст) Экспорт
	
	Оповещение = Новый ОписаниеОповещения(
		"СертификатСтрахователяПредставлениеНачалоВыбораПослеОпределенияСертификатовФСС", ЭтотОбъект, ВходящийКонтекст);
	
	КонтекстЭДО.ОпределитьЗадаваемыеСертификатыФСС(
		Оповещение,
		ВходящийКонтекст.СертификатСтрахователя,
		Запись.СертификатФССОтпечаток,
		Запись.СертификатФССЭЛНОтпечаток,
		ВходящийКонтекст.ЭтоЭлектроннаяПодписьВМоделиСервиса);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатСтрахователяПредставлениеНачалоВыбораПослеОпределенияСертификатовФСС(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Результат.СертификатФССОтпечаток) Тогда
		Запись.СертификатФССОтпечаток = Результат.СертификатФССОтпечаток;
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса,
			Элементы.СертификатФССПредставление,
			Результат.СертификатФССОтпечаток,
			ЭтотОбъект,
			"СертификатФССПредставление");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Результат.СертификатФССЭЛНОтпечаток) Тогда
		Запись.СертификатФССЭЛНОтпечаток = Результат.СертификатФССЭЛНОтпечаток;
		Запись.ТестовыйСерверФССЭЛН = Ложь;
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса,
			Элементы.СертификатФССЭЛНПредставление,
			Результат.СертификатФССЭЛНОтпечаток,
			ЭтотОбъект,
			"СертификатФССЭЛНПредставление");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССПредставлениеНачалоВыбораЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	Элемент = ВходящийКонтекст.Элемент;
	
	Если Результат.Выполнено Тогда
		Запись.СертификатФССОтпечаток = Результат.ВыбранноеЗначение.Отпечаток;
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса,
			Элемент,
			Результат.ВыбранноеЗначение.Отпечаток,
			ЭтотОбъект,
			"СертификатФССПредставление"
			);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФССЭЛНПредставлениеНачалоВыбораЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	Элемент = ВходящийКонтекст.Элемент;
	
	Если Результат.Выполнено Тогда
		Запись.СертификатФССЭЛНОтпечаток = Результат.ВыбранноеЗначение.Отпечаток;
		Запись.ТестовыйСерверФССЭЛН = (СтрНайти(Результат.ВыбранноеЗначение.Владелец, "ТЕСТОВЫЙ") > 0);
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса,
			Элемент,
			Результат.ВыбранноеЗначение.Отпечаток,
			ЭтотОбъект,
			"СертификатФССЭЛНПредставление"
			);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьЭлементов()
	
	Элементы.НадписьСертификатСтрахователя.Доступность = Запись.ИспользоватьОбмен;
	Элементы.ИспользоватьНесколько.Доступность = Запись.ИспользоватьОбмен
		И (ЭтоПолноправныйПользователь ИЛИ НЕ ИспользоватьНесколькоСохраненное);
	Элементы.СертификатСтрахователяПредставление.Доступность = Запись.ИспользоватьОбмен;
	Элементы.НадписьСертификатФСС.Доступность = Запись.ИспользоватьОбмен;
	Элементы.СертификатФССПредставление.Доступность = Запись.ИспользоватьОбмен;
	Элементы.НадписьСертификатФССЭЛН.Доступность = Запись.ИспользоватьОбмен;
	Элементы.СертификатФССЭЛНПредставление.Доступность = Запись.ИспользоватьОбмен;
	Элементы.ТестовыйСерверФССЭЛН.Доступность = Запись.ИспользоватьОбмен;
	Элементы.НадписьАвтонастройка.Доступность = Запись.ИспользоватьОбмен;
	Элементы.ИспользоватьАвтонастройку.Доступность = Запись.ИспользоватьОбмен;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьСертификатСтрахователя(ВыборЕслиНеЗаданыПользовательские = Ложь)
	
	Если Запись.ИспользоватьНесколько = Истина Тогда
		ТекущийПользователь = ПользователиКлиент.ТекущийПользователь();
		ЕстьСертификатыСтрахователейПользователей = Ложь;
		Для каждого СертификатСтрахователяПользователя Из СертификатыСтрахователейПользователей Цикл
			ОтпечатокСертификатаСтрахователя = СертификатСтрахователяПользователя.Представление;
			Если ЗначениеЗаполнено(ОтпечатокСертификатаСтрахователя) Тогда
				ЕстьСертификатыСтрахователейПользователей = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ЕстьСертификатыСтрахователейПользователей Тогда
			СертификатСтрахователяПользователя = СертификатыСтрахователейПользователей.НайтиПоЗначению(ТекущийПользователь);
			ОтпечатокСертификатаСтрахователя = ?(СертификатСтрахователяПользователя = Неопределено,
				"", СертификатСтрахователяПользователя.Представление);
		Иначе
			ОтпечатокСертификатаСтрахователя = "";
		КонецЕсли;
		
	Иначе
		ОтпечатокСертификатаСтрахователя = Запись.СертификатСтрахователяОтпечаток;
	КонецЕсли;
	
	Если ВыборЕслиНеЗаданыПользовательские И Запись.ИспользоватьНесколько = Истина
		И НЕ ЕстьСертификатыСтрахователейПользователей Тогда
		
		ВыбратьНесколькоСертификатовСтрахователя(Истина);
		
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтобразитьСертификатСтрахователяПослеОтображения", ЭтотОбъект);
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса,
			Элементы.СертификатСтрахователяПредставление,
			ОтпечатокСертификатаСтрахователя,
			ЭтотОбъект,
			"СертификатСтрахователяПредставление",
			ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьСертификатСтрахователяПослеОтображения(Результат, ВходящийКонтекст) Экспорт
	
	СкорректироватьПредставлениеСертификатаСтрахователя();
	
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура СкорректироватьПредставлениеСертификатаСтрахователя()
	
	Если Запись.ИспользоватьНесколько = Истина Тогда
		ТекущийПользователь = ПользователиКлиент.ТекущийПользователь();
		СертификатСтрахователяПользователя = СертификатыСтрахователейПользователей.НайтиПоЗначению(ТекущийПользователь);
		ОтпечатокСертификатаСтрахователя = ?(СертификатСтрахователяПользователя = Неопределено,
			"", СертификатСтрахователяПользователя.Представление);
		
		СертификатСтрахователяТекущегоПользователяЗадан = Ложь;
		КоличествоСертификатовСтрахователейПользователей = 0;
		Для каждого СертификатСтрахователяПользователя Из СертификатыСтрахователейПользователей Цикл
			ОтпечатокСертификатаСтрахователя = СертификатСтрахователяПользователя.Представление;
			Если ЗначениеЗаполнено(ОтпечатокСертификатаСтрахователя) Тогда
				КоличествоСертификатовСтрахователейПользователей = КоличествоСертификатовСтрахователейПользователей + 1;
				
				Если СертификатСтрахователяПользователя.Значение = ТекущийПользователь Тогда
					СертификатСтрахователяТекущегоПользователяЗадан = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если СертификатСтрахователяТекущегоПользователяЗадан Тогда
			Если КоличествоСертификатовСтрахователейПользователей > 1 Тогда
				ТекстСообщения = НСтр("ru = 'и еще %1'");
				СертификатСтрахователяПредставление = СертификатСтрахователяПредставление + " " + СтрШаблон(
					ТекстСообщения,
					Строка(КоличествоСертификатовСтрахователейПользователей - 1));
			КонецЕсли;
		ИначеЕсли КоличествоСертификатовСтрахователейПользователей > 0 Тогда
			ТекстСообщения = ПростоеСклонение(
				КоличествоСертификатовСтрахователейПользователей,
				НСтр("ru = '%1 сертификат'"),
				НСтр("ru = '%1 сертификата'"),
				НСтр("ru = '%1 сертификатов'"));
			СертификатСтрахователяПредставление = СтрШаблон(
				ТекстСообщения,
				Строка(КоличествоСертификатовСтрахователейПользователей));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПростоеСклонение(Знач Числ, Форма1, Форма2, Форма3) Экспорт
	
	Числ = ?(Числ < 0, -Числ, Числ) % 100;
	Числ1 = Числ % 10;
	Если (Числ > 10) И (Числ < 20) Тогда
		Возврат Форма3;
	КонецЕсли;
	Если (Числ1 > 1) И (Числ1 < 5) Тогда
		Возврат Форма2;
	КонецЕсли;
	Если (Числ1 = 1) Тогда 
		Возврат Форма1;
	КонецЕсли;
	
	Возврат Форма3;
	
КонецФункции

&НаСервереБезКонтекста
Функция НастройкиОбменаФССОрганизации(ОрганизацияСсылка)
	
	ЗаписьПоОрганизации = РегистрыСведений.НастройкиОбменаФСС.СоздатьМенеджерЗаписи();
	ЗаписьПоОрганизации.Организация = ОрганизацияСсылка;
	ЗаписьПоОрганизации.Пользователь = Справочники.Пользователи.ПустаяСсылка();
	ЗаписьПоОрганизации.Прочитать();
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьНесколько", 			ЗаписьПоОрганизации.ИспользоватьНесколько = Истина);
	Результат.Вставить("СертификатСтрахователяОтпечаток", 	ЗаписьПоОрганизации.СертификатСтрахователяОтпечаток);
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция СписокПользователейИСертификатовСтрахователей(ОрганизацияСсылка)
	
	СписокПользователейНастроек = Новый СписокЗначений;
	
	Если НЕ ЗначениеЗаполнено(ОрганизацияСсылка) Тогда
		Возврат СписокПользователейНастроек;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Пользователи.Ссылка КАК Пользователь,
		|	Пользователи.Наименование КАК НаименованиеПользователя,
		|	НастройкиОбменаФСС.СертификатСтрахователяОтпечаток КАК СертификатСтрахователяОтпечаток
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиОбменаФСС КАК НастройкиОбменаФСС
		|		ПО НастройкиОбменаФСС.Организация = &Организация
		|		И Пользователи.Ссылка = НастройкиОбменаФСС.Пользователь
		|ГДЕ
		|	НЕ Пользователи.Недействителен
		|	И НЕ Пользователи.Служебный
		|	И Пользователи.ИдентификаторПользователяИБ <> &ПустойИдентификаторПользователяИБ
		|
		|УПОРЯДОЧИТЬ ПО
		|	НаименованиеПользователя";
	
	Запрос.УстановитьПараметр("Организация", ОрганизацияСсылка);
	ПустойИдентификаторПользователяИБ = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	Запрос.УстановитьПараметр("ПустойИдентификаторПользователяИБ", ПустойИдентификаторПользователяИБ);
	ТаблицаНастроек = Запрос.Выполнить().Выгрузить();
	
	Для каждого СтрокаТаблицы Из ТаблицаНастроек Цикл
		СписокПользователейНастроек.Добавить(СтрокаТаблицы.Пользователь, СтрокаТаблицы.СертификатСтрахователяОтпечаток);
	КонецЦикла;
	
	Возврат СписокПользователейНастроек;
	
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ЭтоЭлектроннаяПодписьВМоделиСервиса =
		ЭлектроннаяПодписьВМоделиСервисаБРОВызовСервера.ЭтоЭлектроннаяПодписьВМоделиСервиса(Запись.Организация);
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	Элементы.ГруппаАвтонастройка.Видимость = (КонтекстЭДОСервер <> Неопределено И КонтекстЭДОСервер.ЕстьВозможностьАвтонастройкиВУниверсальномФормате(Запись.Организация));
	
	Если НЕ ЭтоПолноправныйПользователь Тогда
		ЗаписьПоОрганизации = НастройкиОбменаФССОрганизации(Запись.Организация);
		Если ЗаписьПоОрганизации.ИспользоватьНесколько = Истина И НЕ Запись.ИспользоватьНесколько = Истина Тогда
			Запись.ИспользоватьНесколько = Истина;
		КонецЕсли;
	КонецЕсли;
	ИспользоватьНесколькоСохраненное = (Запись.ИспользоватьНесколько = Истина);
	
	СертификатыСтрахователейПользователей = СписокПользователейИСертификатовСтрахователей(Запись.Организация);
	Элементы.ИспользоватьНесколько.Видимость = СертификатыСтрахователейПользователей.Количество() > 1
		ИЛИ Запись.ИспользоватьНесколько = Истина;
	
КонецПроцедуры

#КонецОбласти
