﻿&НаКлиенте
Перем КонтекстЭДО;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ОрганизацияСсылка) Тогда
		
		ЗаписьПоОрганизации = РегистрыСведений.НастройкиОбменаФТС.СоздатьМенеджерЗаписи();
		ЗаписьПоОрганизации.Организация = Параметры.ОрганизацияСсылка;
		ЗаписьПоОрганизации.Прочитать();
		
		Если ЗначениеЗаполнено(ЗаписьПоОрганизации.Организация) Тогда
			ЗначениеВДанныеФормы(ЗаписьПоОрганизации, Запись);
		Иначе
			Запись.Организация = Параметры.ОрганизацияСсылка;
		КонецЕсли;
		
	КонецЕсли;
	
	ЭтоЭлектроннаяПодписьВМоделиСервиса = ЭлектроннаяПодписьВМоделиСервисаБРОВызовСервера.ЭтоЭлектроннаяПодписьВМоделиСервиса(Запись.Организация);
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.СкрытьЭлементыФормыПриИспользованииОднойОрганизации(ЭтаФорма, "НадписьОрганизация");
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	СвойстваОрганизацииИУчетнойЗаписи = Неопределено;
	Если КонтекстЭДОСервер <> Неопределено Тогда
		СвойстваОрганизацииИУчетнойЗаписи = КонтекстЭДОСервер.ЕстьВозможностьАвтонастройкиВУниверсальномФормате(
			Запись.Организация, Истина);
	КонецЕсли;
	
	Элементы.ГруппаАвтонастройка.Видимость =
		(СвойстваОрганизацииИУчетнойЗаписи <> Неопределено
		И СвойстваОрганизацииИУчетнойЗаписи.ЕстьВозможностьАвтонастройкиВУниверсальномФормате);
	Элементы.ГруппаИнформация1СОтчетностьНеИспользуется.Видимость =
		(СвойстваОрганизацииИУчетнойЗаписи = Неопределено
		ИЛИ СвойстваОрганизацииИУчетнойЗаписи.ВидОбменаСКонтролирующимиОрганами <>
			ПредопределенноеЗначение("Перечисление.ВидыОбменаСКонтролирующимиОрганами.ОбменВУниверсальномФормате")
		ИЛИ НЕ ЗначениеЗаполнено(СвойстваОрганизацииИУчетнойЗаписи.УчетнаяЗаписьОбмена));
	
	КлючСохраненияПоложенияОкна = "НастройкиФТС" + ?(Элементы.ГруппаАвтонастройка.Видимость, "Автонастройка", "")
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
Процедура ИспользоватьОбменПриИзменении(Элемент)
	
	ОбновитьДоступностьИАвтоОтметкуЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатАбонентаПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КриптографияЭДКОКлиент.ПоказатьСертификат(
		Новый Структура("Отпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса",
		Запись.СертификатАбонентаОтпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса));
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатАбонентаПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Запись.СертификатАбонентаОтпечаток = "";
	СертификатАбонентаПредставление = "";
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		ЭтоЭлектроннаяПодписьВМоделиСервиса,
		Элемент, 
		Запись.СертификатАбонентаОтпечаток,
		ЭтотОбъект,
		"СертификатАбонентаПредставление");
	
	Модифицированность = Истина;
	
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
	
	ОбновитьДоступностьИАвтоОтметкуЭлементов();
	
	КонтекстЭДО.УправлениеОтображениемОрганизации(ЭтаФорма, Запись.Организация);
	
	ПараметрыОтображенияСертификатов = Новый Массив;
	
	ПараметрыОтображенияСертификата = Новый Структура;
	ПараметрыОтображенияСертификата.Вставить("ПолеВвода", 								Элементы.СертификатАбонентаПредставление);
	ПараметрыОтображенияСертификата.Вставить("Сертификат", 								Запись.СертификатАбонентаОтпечаток);
	ПараметрыОтображенияСертификата.Вставить("ИмяРеквизитаПредставлениеСертификата", 	"СертификатАбонентаПредставление");
	
	ПараметрыОтображенияСертификатов.Добавить(ПараметрыОтображенияСертификата);
	
	КриптографияЭДКОКлиент.ОтобразитьПредставленияСертификатов(ПараметрыОтображенияСертификатов, ЭтотОбъект, ЭтоЭлектроннаяПодписьВМоделиСервиса);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатАбонентаПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения(
		"СертификатАбонентаПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));

	КриптографияЭДКОКлиент.ВыбратьСертификат(
		Оповещение, ЭтоЭлектроннаяПодписьВМоделиСервиса, Запись.СертификатАбонентаОтпечаток, "My");

КонецПроцедуры

&НаКлиенте
Процедура СертификатАбонентаПредставлениеНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элемент = ДополнительныеПараметры.Элемент;
	
	Если Результат.Выполнено Тогда
		Запись.СертификатАбонентаОтпечаток = Результат.ВыбранноеЗначение.Отпечаток;
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса,
			Элемент, 
			Результат.ВыбранноеЗначение.Отпечаток, 
			ЭтотОбъект,
			"СертификатАбонентаПредставление");
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьИАвтоОтметкуЭлементов()
	
	Элементы.НадписьСертификатАбонента.Доступность = Запись.ИспользоватьОбмен;
	Элементы.СертификатАбонентаПредставление.Доступность = Запись.ИспользоватьОбмен;
	Элементы.НадписьЛогин.Доступность = Запись.ИспользоватьОбмен;
	Элементы.Логин.Доступность = Запись.ИспользоватьОбмен;
	Элементы.НадписьПароль.Доступность = Запись.ИспользоватьОбмен;
	Элементы.Пароль.Доступность = Запись.ИспользоватьОбмен;
	Элементы.НадписьАвтонастройка.Доступность = Запись.ИспользоватьОбмен;
	Элементы.ИспользоватьАвтонастройку.Доступность = Запись.ИспользоватьОбмен;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ИзменениеНастроекЭДООрганизации", Запись.Организация);
КонецПроцедуры

#КонецОбласти
