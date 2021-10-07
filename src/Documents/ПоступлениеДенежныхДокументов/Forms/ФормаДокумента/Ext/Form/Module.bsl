﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗаполнитьНовыйДокумент();
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2021-07-05 (#4145)
	ок_УправлениеФормами.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2021-07-05 (#4145)
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Модифицированность = Истина;
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтотОбъект, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "ПроведениеПоступлениеДенежныхДокументов";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПоступлениеДенежныхДокументов", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидОперации) Тогда
		Возврат;
	КонецЕсли;
	
	ВидОперацииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаВходящегоДокументаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДатаВходящегоДокумента) И НЕ Объект.Проведен Тогда
		Объект.Дата = Объект.ДатаВходящегоДокумента + (Объект.Дата - НачалоДня(Объект.Дата));
		ДатаПриИзмененииНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаДенежныхДокументовПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СчетУчетаДенежныхДокументов) Тогда
		СчетУчетаДенежныхДокументовПриИзмененииСервер();
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаДокументаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ВалютаДокумента) Тогда
		
		ПараметрыДокумента = ПолучитьДанныеВалютаПриИзменении(
			Объект.ВалютаДокумента,
			Объект.Дата,
			Объект.ВидОперации, Объект.ДоговорКонтрагента);
		ЗаполнитьЗначенияСвойств(Объект, ПараметрыДокумента);
		
		УстановитьПараметрыВыбора(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект. Контрагент) Тогда
		ПараметрыДокумента = Новый Структура("Организация, Контрагент, ДоговорКонтрагента, СчетУчетаДенежныхДокументов, ВалютаДокумента",
			Объект.Организация, Объект.Контрагент, Объект.ДоговорКонтрагента, Объект.СчетУчетаДенежныхДокументов, Объект.ВалютаДокумента);
		
		ПараметрыДокумента = ПолучитьДанныеКонтрагентПриИзменении(ПараметрыДокумента, Объект.Дата);
		ЗаполнитьЗначенияСвойств(Объект, ПараметрыДокумента);
	КонецЕсли;
	
	УстановитьДоступностьСвязанныхЭлементов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентОкончаниеВводаТекста(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСКонтрагентамиБПКлиент.КонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодотчетноеЛицоПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Объект.ПринятоОт = ПолучитьТекстПринятоОт(Объект.Организация, Объект.Контрагент, Объект.Дата);
	Иначе
		Объект.ПринятоОт = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятоОтПрочееНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФормаВыбора = ОткрытьФорму("Справочник.ФизическиеЛица.ФормаСписка",
		Новый Структура("РежимВыбора", Истина), Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятоОтПрочееОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Объект.ПринятоОт = ПолучитьТекстПринятоОт(Объект.Организация, ВыбранноеЗначение, Объект.Дата);
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаРасчетовСКонтрагентомПрочееПриИзменении(Элемент)
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСчета(
		ЭтотОбъект, Объект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКт1ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(1);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКт1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКт2ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(2);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКт2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКт3ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(3);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКт3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДенежныеДокументы

&НаКлиенте
Процедура ДенежныеДокументыДенежныйДокументПриИзменении(Элемент)
	
	СтрокаПлатеж = Элементы.ДенежныеДокументы.ТекущиеДанные;
	Если СтрокаПлатеж.Количество = 0 Тогда
		СтрокаПлатеж.Количество = 1;
	КонецЕсли;
	
	Стоимость = ПолучитьСтоимостьИзДенежногоДокумента(СтрокаПлатеж.ДенежныйДокумент);
	СтрокаПлатеж.Сумма = Стоимость * СтрокаПлатеж.Количество;
	
КонецПроцедуры

&НаКлиенте
Процедура ДенежныеДокументыКоличествоПриИзменении(Элемент)
	
	СтрокаПлатеж = Элементы.ДенежныеДокументы.ТекущиеДанные;
	Если ЗначениеЗаполнено(СтрокаПлатеж.ДенежныйДокумент) Тогда
		Стоимость = ПолучитьСтоимостьИзДенежногоДокумента(СтрокаПлатеж.ДенежныйДокумент);
	Иначе
		Стоимость = 0;
	КонецЕсли;
	
	СтрокаПлатеж.Сумма = Стоимость * СтрокаПлатеж.Количество;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2021-07-05 (#4145)
&НаКлиенте
Процедура ЗаполнитьIDИзЗаявкиНаДоговор(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Укажите договор контрагента"); 
		Возврат;
		
	КонецЕсли; 
	
	СтруктураПараметрыВыбора = Новый Структура;
	СтруктураПараметрыВыбора.Вставить("РежимВыбора",		Истина);
	СтруктураПараметрыВыбора.Вставить("МножественныйВыбор",	Ложь);
	СтруктураПараметрыВыбора.Вставить("ЗакрыватьПриВыборе",	Истина);
	
	Если ЗначениеЗаполнено(Объект.ДатаВходящегоДокумента) Тогда
		СтруктураПараметрыВыбора.Вставить("ДатаНачала",		НачалоМесяца(Объект.ДатаВходящегоДокумента));
		СтруктураПараметрыВыбора.Вставить("ДатаОкончания",	КонецМесяца(Объект.ДатаВходящегоДокумента));
	ИначеЕсли ЗначениеЗаполнено(Объект.Дата) Тогда
		СтруктураПараметрыВыбора.Вставить("ДатаНачала",		НачалоМесяца(Объект.Дата));
		СтруктураПараметрыВыбора.Вставить("ДатаОкончания",	КонецМесяца(Объект.Дата));
	Иначе
		СтруктураПараметрыВыбора.Вставить("ДатаНачала",		НачалоМесяца(ТекущаяДата()));
		СтруктураПараметрыВыбора.Вставить("ДатаОкончания",	КонецМесяца(ТекущаяДата()));
	КонецЕсли;
	
	ЗаявкаНаДоговорФормаВыбора = ПолучитьФорму("Документ.рс_ЗаявкаНаДоговор.Форма.ФормаВыбораУправляемая_Дерево", СтруктураПараметрыВыбора, Этаформа);
	ЗаявкаНаДоговорФормаВыбора.ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ЗаполнитьIDИзЗаявкиНаДоговорПриЗакрытии", ЭтаФорма); 
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ЗаявкаНаДоговорФормаВыбора.Список,
		"Организация",
		Объект.Организация,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		Истина,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный
		);
																			
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ЗаявкаНаДоговорФормаВыбора.Список,
		"Контрагент",
		Объект.Контрагент,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		Истина,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный
		);
																			
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ЗаявкаНаДоговорФормаВыбора.Список,
		"ДоговорКонтрагента",
		Объект.ДоговорКонтрагента,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		Истина,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный
		);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ЗаявкаНаДоговорФормаВыбора.Список,
		"Проведен",
		Истина,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		Истина,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный
		);
		
	ЗаявкаНаДоговорФормаВыбора.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьIDИзЗаявкиНаДоговорПриЗакрытии(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено
		ИЛИ НЕ ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Возврат;
	КонецЕсли; 
	
	ВыбраннаяЗаявкаНаДоговор = Неопределено;
	Если ТипЗнч(РезультатЗакрытия) = Тип("КлючСтрокиДинамическогоСписка") Тогда
		
		Для каждого КлючЗначение Из РезультатЗакрытия Цикл
			
			Если КлючЗначение.Ключ = "Ссылка"
				И ТипЗнч(КлючЗначение.Значение) = Тип("ДокументСсылка.рс_ЗаявкаНаДоговор") Тогда
			
				ВыбраннаяЗаявкаНаДоговор = КлючЗначение.Значение;
			
			КонецЕсли;
		
		КонецЦикла; 
		
	ИначеЕсли ТипЗнч(РезультатЗакрытия) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		
		Если РезультатЗакрытия.ИмяГруппировки = "Ссылка"
			И ТипЗнч(РезультатЗакрытия.Ключ) = Тип("ДокументСсылка.рс_ЗаявкаНаДоговор") Тогда
		
			ВыбраннаяЗаявкаНаДоговор = РезультатЗакрытия.Ключ;
			
		ИначеЕсли РезультатЗакрытия.РодительскаяГруппировка <> Неопределено Тогда 
			
			ЗаполнитьIDИзЗаявкиНаДоговорПриЗакрытии(РезультатЗакрытия.РодительскаяГруппировка, ДополнительныеПараметры);
			Возврат;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(РезультатЗакрытия) = Тип("ДокументСсылка.рс_ЗаявкаНаДоговор") Тогда
		
		ВыбраннаяЗаявкаНаДоговор = РезультатЗакрытия;
		
	КонецЕсли;  
	
	Если ВыбраннаяЗаявкаНаДоговор <> Неопределено Тогда
	
		СтруктураЗначенийРеквизитов = ОК_ОбщегоНазначения.ПолучитьЗначенияРеквизитов(ВыбраннаяЗаявкаНаДоговор, "ID");
		Объект.ОК_ID_Разноска = СтруктураЗначенийРеквизитов.ID;
	
	КонецЕсли;
	
КонецПроцедуры
//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2021-07-05 (#4145)

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// ВалютаДокумента

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ВалютаДокумента");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"СчетУчетаДенежныхДокументовВалютный", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзмененииНаКлиенте()
	
	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;
	
	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата,
		ТекущаяДатаДокумента, Объект.ВалютаДокумента, ВалютаРегламентированногоУчета);
	
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхДокументов.ПоступлениеОтПоставщика") Тогда
		
		Элементы.ГруппаПолученоОтПоставщика.Видимость      = Истина;
		Элементы.ГруппаПринятоОтПодотчетногоЛица.Видимость = Ложь;
		Элементы.ГруппаПрочее.Видимость                    = Ложь;
		
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхДокументов.ПоступлениеОтПодотчетногоЛица") Тогда
		
		Элементы.ГруппаПолученоОтПоставщика.Видимость      = Ложь;
		Элементы.ГруппаПринятоОтПодотчетногоЛица.Видимость = Истина;
		Элементы.ГруппаПрочее.Видимость                    = Ложь;
		
	Иначе
		
		Элементы.ГруппаПолученоОтПоставщика.Видимость      = Ложь;
		Элементы.ГруппаПринятоОтПодотчетногоЛица.Видимость = Ложь;
		Элементы.ГруппаПрочее.Видимость                    = Истина;
		
	КонецЕсли;
	
	УстановитьОграничениеТипаКонтрагента(Форма);
	
	Элементы.ВалютаДокумента.Доступность = Форма.СчетУчетаДенежныхДокументовВалютный;
	
	УстановитьДоступностьСвязанныхЭлементов(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьСвязанныхЭлементов(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Элементы.ПодразделениеОрганизации.Доступность = ЗначениеЗаполнено(Объект.Организация);
	Элементы.ДоговорКонтрагента.Доступность       = ЗначениеЗаполнено(Объект.Контрагент);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыВыбора(Форма)
	
	Валютный = Форма.Объект.ВалютаДокумента <> Форма.ВалютаРегламентированногоУчета;
	
	НовыйПараметр = Новый ПараметрВыбора("Отбор.Валютный", Валютный);
	НовыйМассивПараметров = Новый Массив();
	НовыйМассивПараметров.Добавить(НовыйПараметр);
	
	ТекущиеПараметрыВыбора = Форма.Элементы.ДоговорКонтрагента.ПараметрыВыбора;
	Для каждого ПараметрВыбора Из ТекущиеПараметрыВыбора Цикл
		Если ПараметрВыбора.Имя <> "Отбор.Валютный" Тогда
			НовыйМассивПараметров.Добавить(ПараметрВыбора);
		КонецЕсли;
	КонецЦикла;
	
	Форма.Элементы.ДоговорКонтрагента.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассивПараметров);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОграничениеТипаКонтрагента(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхДокументов.ПоступлениеОтПоставщика") Тогда
		Элементы.Контрагент.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
		Элементы.Контрагент.Заголовок = "Контрагент";
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхДокументов.ПоступлениеОтПодотчетногоЛица") Тогда
		Элементы.Контрагент.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица");
		Элементы.Контрагент.Заголовок = "Подотчетное лицо";
	Иначе // .ПрочаяВыдача
		Элементы.Контрагент.ОграничениеТипа = Новый ОписаниеТипов("Неопределено");
		Элементы.Контрагент.Заголовок = "Контрагент";
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСтоимостьИзДенежногоДокумента(Знач ДенежныйДокумент)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДенежныйДокумент, "Стоимость");
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеВалютаПриИзменении(Знач ВалютаДокумента, Знач Дата, Знач ВидОперации, Знач ДоговорКонтрагента)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("ДоговорКонтрагента", ДоговорКонтрагента);
	
	СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, Дата);
	СтруктураДанные.Вставить("КурсВзаиморасчетов"     , СтруктураКурса.Курс);
	СтруктураДанные.Вставить("КратностьВзаиморасчетов", СтруктураКурса.Кратность);
	
	Если ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхДокументов.ПоступлениеОтПоставщика
		И ЗначениеЗаполнено(ДоговорКонтрагента)
		И ДоговорКонтрагента.ВалютаВзаиморасчетов <> ВалютаДокумента Тогда
		СтруктураДанные.Вставить("ДоговорКонтрагента", Неопределено);
	КонецЕсли;
	
	Возврат СтруктураДанные;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеКонтрагентПриИзменении(ПараметрыДокумента, ДатаДокумента)
	
	СписокВидовДоговоров = Новый СписокЗначений;
	СписокВидовДоговоров.Добавить(Перечисления.ВидыДоговоровКонтрагентов.Прочее);
	
	СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(ПараметрыДокумента.СчетУчетаДенежныхДокументов);
	СтруктураДополнительныхПараметров = Новый Структура();
	СтруктураДополнительныхПараметров.Вставить("Валютный", Новый Структура("ЗначениеОтбора", СвойстваСчета.Валютный));
	СтруктураДополнительныхПараметров.Вставить("ВалютаВзаиморасчетов", Новый Структура("ЗначениеОтбора", ПараметрыДокумента.ВалютаДокумента));
	
	ПараметрыДокумента = ЗаполнениеДокументов.ПолучитьДанныеКонтрагентПриИзменении(
		ПараметрыДокумента, СписокВидовДоговоров, СтруктураДополнительныхПараметров);
	
	СведенияОКонтрагенте = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ПараметрыДокумента.Контрагент, ДатаДокумента);
	ПараметрыДокумента.Вставить("ПринятоОт", ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОКонтрагенте, "НаименованиеДляПечатныхФорм,"));
	
	Возврат ПараметрыДокумента;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТекстПринятоОт(Знач Организация, Знач ФизЛицо, Знач Дата)
	
	ДанныеФизЛица = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(Организация, ФизЛицо, Дата, Истина);
	
	Возврат ДанныеФизЛица.Представление;
	
КонецФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
	ТекущаяДатаДокумента           = Объект.Дата;
	ТекущийВидОперации             = Объект.ВидОперации;
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Объект.СчетУчетаДенежныхДокументов);
	СчетУчетаДенежныхДокументовВалютный = ДанныеСчета.Валютный;
	
	Элементы.Контрагент.ОграничениеТипа      = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	Элементы.ПодотчетноеЛицо.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица");
	
	ЗаполнитьСчетаДенежныхДокументов();
	
	УстановитьПараметрыВыбора(ЭтотОбъект);
	
	УстановитьСостояниеДокумента();
	
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоШапки(
		ЭтотОбъект, Объект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНовыйДокумент()
	
	ПараметрыДокумента = ПолучитьДанныеВалютаПриИзменении(
		Объект.ВалютаДокумента,
		Объект.Дата,
		Объект.ВидОперации,
		Объект.ДоговорКонтрагента);
	ЗаполнитьЗначенияСвойств(Объект, ПараметрыДокумента);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
	ПараметрыДокумента = Новый Структура;
	ПараметрыДокумента.Вставить("Организация",              Объект.Организация);
	ПараметрыДокумента.Вставить("Дата",                     Объект.Дата);
	ПараметрыДокумента.Вставить("ПодразделениеОрганизации", Объект.ПодразделениеОрганизации);
	ПараметрыДокумента.Вставить("ДоговорКонтрагента",       Объект.ДоговорКонтрагента);
	
	ПараметрыДокумента = ЗаполнениеДокументов.ПолучитьДанныеОрганизацияПриИзменении(ПараметрыДокумента);
	ЗаполнитьЗначенияСвойств(Объект, ПараметрыДокумента);
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииОрганизации(
		ЭтотОбъект, Объект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
	Если (Объект.ВалютаДокумента <> ВалютаРегламентированногоУчета) Тогда
		СтруктураКурсаДокумента        = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Объект.ВалютаДокумента, Объект.Дата);
		Объект.КурсВзаиморасчетов      = СтруктураКурсаДокумента.Курс;
		Объект.КратностьВзаиморасчетов = СтруктураКурсаДокумента.Кратность;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ВидОперацииПриИзмененииНаСервере()
	
	Объект.ДоговорКонтрагента             = Неопределено;
	Объект.СчетУчетаРасчетовСКонтрагентом = Неопределено;
	Объект.ПринятоОт                      = "";
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСчета(
		ЭтотОбъект, Объект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
	УправлениеФормой(ЭтотОбъект);
	
	Если Элементы.Контрагент.ОграничениеТипа.Типы().Количество() = 0 Тогда
		Объект.Контрагент = Неопределено;
	Иначе
		Объект.Контрагент = Элементы.Контрагент.ОграничениеТипа.ПривестиЗначение(Объект.Контрагент);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СчетУчетаДенежныхДокументовПриИзмененииСервер()
	
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Объект.СчетУчетаДенежныхДокументов);
	СчетУчетаДенежныхДокументовВалютный = ДанныеСчета.Валютный;
	
	Если НЕ СчетУчетаДенежныхДокументовВалютный Тогда
		Объект.ВалютаДокумента = ВалютаРегламентированногоУчета;
		УстановитьПараметрыВыбора(ЭтотОбъект);
		ПараметрыДокумента = ПолучитьДанныеВалютаПриИзменении(
			Объект.ВалютаДокумента,
			Объект.Дата,
			Объект.ВидОперации,
			Объект.ДоговорКонтрагента);
		ЗаполнитьЗначенияСвойств(Объект, ПараметрыДокумента);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСчетаДенежныхДокументов()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПланСчетов.Ссылка КАК Счет
	|ИЗ
	|	ПланСчетов.Хозрасчетный.ВидыСубконто КАК ПланСчетов
	|ГДЕ
	|	НЕ ПланСчетов.Ссылка.ЗапретитьИспользоватьВПроводках
	|	И ПланСчетов.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ДенежныеДокументы)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПланСчетов.Ссылка.Код";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		МассивСчетов = Результат.Выгрузить().ВыгрузитьКолонку("Счет");
	Иначе
		МассивСчетов = Новый Массив;
	КонецЕсли;
	
	Если МассивСчетов.Количество() > 0 Тогда
		НовыйМассивПараметров = Новый Массив();
		НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(МассивСчетов)));
		НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ЗапретитьИспользоватьВПроводках", Ложь));
		Элементы.СчетУчетаДенежныхДокументов.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассивПараметров);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтотОбъект);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПриИзмененииСубконто(НомерСубконто)
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСубконто(
		ЭтотОбъект, Объект, НомерСубконто, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеОбъекта = БухгалтерскийУчетКлиентСервер.ДанныеУстановкиПараметровСубконто(
		Объект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтотОбъект, Элемент, СтандартнаяОбработка, ДанныеОбъекта);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыУстановкиСвойствСубконто(Форма)

	Результат = БухгалтерскийУчетКлиентСервер.ПараметрыУстановкиСвойствСубконтоПоШаблону(
		"СубконтоКт", "", "СубконтоКт", "", "СчетУчетаРасчетовСКонтрагентом");
		
	Результат.ДопРеквизиты.Вставить("Организация", Форма.Объект.Организация);
	
	Возврат Результат;

КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
