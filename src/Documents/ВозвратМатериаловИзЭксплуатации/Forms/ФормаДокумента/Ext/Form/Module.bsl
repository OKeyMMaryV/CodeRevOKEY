﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;

	// Активизировать первую непустую табличную часть
	СписокТабличныхЧастей = Новый СписокЗначений;
	СписокТабличныхЧастей.Добавить("Спецодежда", "Спецодежда");
	СписокТабличныхЧастей.Добавить("Спецоснастка", "Спецоснастка");
	
	АктивизироватьТабличнуюЧасть = ОбщегоНазначенияБПВызовСервера.ПолучитьПервуюНепустуюВидимуюТабличнуюЧасть(
		ЭтаФорма, СписокТабличныхЧастей);
	ОбщегоНазначенияБПВызовСервера.АктивизироватьЭлементФормы(ЭтаФорма, АктивизироватьТабличнуюЧасть);

	УстановитьУсловноеОформление();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатуры.Форма.Форма" Тогда
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, ИсточникВыбора.ИмяТаблицы);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);

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
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "ПроведениеВозвратМатериаловИзЭксплуатации";
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
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента);
		
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Склад) Тогда
		СкладПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСпецодежда

&НаКлиенте
Процедура СпецодеждаНоменклатураПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Спецодежда.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура("Номенклатура, Количество, СчетУчета, СчетПередачи");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	СпецодеждаНоменклатураПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);

КонецПроцедуры

&НаКлиенте
Процедура СпецодеждаПартияМатериаловВЭксплуатацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОткрытьФормуВыбораПартии(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСпецоснастка

&НаКлиенте
Процедура СпецоснасткаПриИзменении(Элемент)

	ОтмечатьПустоеПодразделение = Объект.Спецоснастка.Количество() > 0;

КонецПроцедуры

&НаКлиенте
Процедура СпецоснасткаНоменклатураПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Спецоснастка.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура("Номенклатура, Количество, СчетУчета, СчетПередачи");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	СпецоснасткаНоменклатураПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);

КонецПроцедуры

&НаКлиенте
Процедура СпецоснасткаПартияМатериаловВЭксплуатацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОткрытьФормуВыбораПартии(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоОстаткамСпецодеждаНажатие(Команда)

	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ПоказатьПредупреждение( , НСтр("ru='Не указана организация!
			|Заполнение невозможно!'"));
		Возврат;
	КонецЕсли;
	
	Если Объект.Спецодежда.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru='При заполнении табличная часть будет очищена.
			|Продолжить?'");
		Оповещение = Новый ОписаниеОповещения("ВопросЗаполнитьПоОстаткамСпецодеждаЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	Иначе
		ЗаполнитьПоОстаткамСпецодеждаНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОстаткамСпецоснасткаНажатие(Команда)

	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ПоказатьПредупреждение( , НСтр("ru='Не указана организация!
			|Заполнение невозможно!'"));
		Возврат;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.ПодразделениеОрганизации) Тогда
		ПоказатьПредупреждение( , НСтр("ru='Не указано подразделение организации!
			|Заполнение невозможно!'"));
		Возврат;
	КонецЕсли;

	Если Объект.Спецоснастка.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru='При заполнении табличная часть будет очищена.
			|Продолжить?'");
		Оповещение = Новый ОписаниеОповещения("ВопросЗаполнитьПоОстаткамСпецостасткаЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	Иначе
		ЗаполнитьПоОстаткамСпецоснасткаНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПодборСпецодеждаНажатие(Команда)

	ОткрытьФорму(
		"Обработка.ПодборНоменклатуры.Форма.Форма",
		ПолучитьПараметрыПодбора("Спецодежда"),
		ЭтаФорма,
		УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ПодборСпецоснасткаНажатие(Команда)

	ОткрытьФорму(
		"Обработка.ПодборНоменклатуры.Форма.Форма",
		ПолучитьПараметрыПодбора("Спецоснастка"),
		ЭтаФорма,
		УникальныйИдентификатор);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ТекущаяДатаДокумента			= Объект.Дата;

	ВалютаРегламентированногоУчета 	= Константы.ВалютаРегламентированногоУчета.Получить();

	УстановитьФункциональныеОпцииФормы();
	
	УстановитьСостояниеДокумента();

	ОтмечатьПустоеПодразделение = Объект.Спецоснастка.Количество() > 0;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// ПодразделениеОрганизации

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ПодразделениеОрганизации");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ОтмечатьПустоеПодразделение", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;

	// Доступность взаимосвязанных полей
	Элементы.ПодразделениеОрганизации.Доступность = ЗначениеЗаполнено(Объект.Организация);

КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()

	ДатаОбработатьИзменение();
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ДатаОбработатьИзменение()

	УстановитьФункциональныеОпцииФормы();

КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	Объект.ПодразделениеОрганизации = ОбщегоНазначенияБПВызовСервера.ПолучитьПодразделение(
		Объект.Организация, Объект.Склад);
	
	ЗаполнитьСчетаУчетаВТабличнойЧастиНаСервере();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура СкладПриИзмененииНаСервере()

	Объект.ПодразделениеОрганизации = ОбщегоНазначенияБПВызовСервера.ПолучитьПодразделение(
		Объект.Организация, Объект.Склад);
	
	ЗаполнитьСчетаУчетаВТабличнойЧастиНаСервере();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСчетаУчетаВТабличнойЧастиНаСервере(ИмяТабличнойЧасти = "")

	Если ПустаяСтрока(ИмяТабличнойЧасти) ИЛИ ИмяТабличнойЧасти = "Спецодежда" Тогда
		Документы.ВозвратМатериаловИзЭксплуатации.ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, "Спецодежда");
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяТабличнойЧасти) ИЛИ ИмяТабличнойЧасти = "Спецоснастка" Тогда
		Документы.ВозвратМатериаловИзЭксплуатации.ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, "Спецоснастка");
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура СпецодеждаНоменклатураПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта)

	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		СтрокаТабличнойЧасти.Номенклатура, ДанныеОбъекта);
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Документы.ВозвратМатериаловИзЭксплуатации.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
		ДанныеОбъекта, СтрокаТабличнойЧасти, "Спецодежда", СведенияОНоменклатуре);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура СпецоснасткаНоменклатураПриИзмененииНаСервере(СтрокаТабличнойЧасти, Знач ДанныеОбъекта)

	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		СтрокаТабличнойЧасти.Номенклатура, ДанныеОбъекта);
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Документы.ВозвратМатериаловИзЭксплуатации.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
		ДанныеОбъекта, СтрокаТабличнойЧасти, "Спецоснастка", СведенияОНоменклатуре);

КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыПодбора(ИмяТаблицы)

	ДатаРасчетов = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);

	ЗаголовокПодбора = НСтр("ru = 'Подбор номенклатуры в %1 (%2)'");
	Если ИмяТаблицы = "Спецодежда" Тогда
		ПредставлениеТаблицы = НСтр("ru = 'Спецодежда'");
	ИначеЕсли ИмяТаблицы = "Спецоснастка" Тогда
		ПредставлениеТаблицы = НСтр("ru = 'Спецоснастка'");
	КонецЕсли;
	ЗаголовокПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ЗаголовокПодбора,
		Объект.Ссылка,
		ПредставлениеТаблицы);

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДатаРасчетов"   , ДатаРасчетов);
	ПараметрыФормы.Вставить("Организация"    , Объект.Организация);
	ПараметрыФормы.Вставить("Подразделение"  , Объект.ПодразделениеОрганизации);
	ПараметрыФормы.Вставить("Валюта"         , ВалютаРегламентированногоУчета);
	ПараметрыФормы.Вставить("ЕстьЦена"       , Ложь);
	ПараметрыФормы.Вставить("ЕстьКоличество" , Истина);
	ПараметрыФормы.Вставить("Заголовок"      , ЗаголовокПодбора);
	ПараметрыФормы.Вставить("СписокПодборов" , ПолучитьСписокПодборов(ИмяТаблицы));
	ПараметрыФормы.Вставить("ИмяТаблицы"     , ИмяТаблицы);
	ПараметрыФормы.Вставить("Услуги"         , Ложь);

	Возврат ПараметрыФормы;

КонецФункции

&НаКлиенте
Функция ПолучитьСписокПодборов(ИмяТаблицы)

	// Список возможных подборов - в Обработка.ПодборНоменклатуры.Форма.Форма.УстановитьТекущийСписок(Форма)
	СписокПодборов = Новый СписокЗначений();
	СписокПодборов.Добавить("", НСтр("ru = 'По справочнику'"));

	Возврат СписокПодборов;

КонецФункции

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, ИмяТаблицы)

	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобраннойНоменклатурыВХранилище);
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
		ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаТоваров, "Номенклатура", Истина), ДанныеОбъекта);
	
	Для Каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		ДанныеСтрокаТаблицы = Неопределено;
		Если ИмяТаблицы = "Спецодежда" Тогда
			// Подготовить строку для добавления, заполнить счета, другие реквизиты, ...
			ДанныеСтрокаТаблицы = Новый Структура("Номенклатура, НазначениеИспользования, Количество, ФизЛицо, СчетУчета, СчетПередачи");
			ЗаполнитьЗначенияСвойств(ДанныеСтрокаТаблицы, СтрокаТовара);
			СтруктураОтбора = Новый Структура("Номенклатура", ДанныеСтрокаТаблицы.Номенклатура); // Надо искать также по физ.лицу, т.к. потом осуществляется проверка на задвоенность по комбинации Номенклатура / Физ.лицо
			
		ИначеЕсли ИмяТаблицы = "Спецоснастка" Тогда
			ДанныеСтрокаТаблицы = Новый Структура("Номенклатура, НазначениеИспользования, Количество, СчетУчета, СчетПередачи");
			ЗаполнитьЗначенияСвойств(ДанныеСтрокаТаблицы, СтрокаТовара);
			СтруктураОтбора = Новый Структура("Номенклатура", ДанныеСтрокаТаблицы.Номенклатура);
			
		КонецЕсли;
		
		Если ДанныеСтрокаТаблицы <> Неопределено Тогда
			
			// Задваивать строки нельзя, это ошибка. Поэтому надо найти строку с такой же номенклатурой
			СтрокаТабличнойЧасти = НайтиСтрокуТабличнойЧасти(ИмяТаблицы, СтруктураОтбора);
			Если СтрокаТабличнойЧасти <> Неопределено Тогда
				// Нашли - увеличиваем количество.
				СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество + СтрокаТовара.Количество;
			Иначе
				// Не нашли - добавляем новую строку.
				СтрокаТабличнойЧасти = Объект[ИмяТаблицы].Добавить();
				СтрокаТабличнойЧасти.Номенклатура = СтрокаТовара.Номенклатура;
				СтрокаТабличнойЧасти.Количество   = СтрокаТовара.Количество;
				
				СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(СтрокаТовара.Номенклатура);
				
				Документы.ВозвратМатериаловИзЭксплуатации.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
					ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТаблицы, СведенияОНоменклатуре);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция НайтиСтрокуТабличнойЧасти(ИмяТабличнойЧасти, СтруктураОтбора)

	СтрокаТабличнойЧасти = Неопределено;

	МассивНайденныхСтрок = Объект[ИмяТабличнойЧасти].НайтиСтроки(СтруктураОтбора);
	Если МассивНайденныхСтрок.Количество() > 0 Тогда
		// Нашли. Вернем первую найденную строку.
		СтрокаТабличнойЧасти = МассивНайденныхСтрок[0];
	КонецЕсли;

	Возврат СтрокаТабличнойЧасти;

КонецФункции

&НаСервере
Процедура ЗаполнитьПоОстаткамСпецодеждаНаСервере()

	Объект.Спецодежда.Очистить();
	
	УчетМатериаловВЭксплуатации.ЗаполнитьСпецодеждуПоОстаткамВЭксплуатации(Объект, Объект.Спецодежда, Ложь);
	
	Документы.ВозвратМатериаловИзЭксплуатации.ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, "Спецодежда");

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОстаткамСпецоснасткаНаСервере()

	Объект.Спецоснастка.Очистить();
	
	УчетМатериаловВЭксплуатации.ЗаполнитьСпецоснасткуПоОстаткамВЭксплуатации(Объект, Объект.Спецоснастка, Ложь);
	
	Документы.ВозвратМатериаловИзЭксплуатации.ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, "Спецоснастка");

КонецПроцедуры

&НаКлиенте
Процедура ВопросЗаполнитьПоОстаткамСпецостасткаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьПоОстаткамСпецоснасткаНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗаполнитьПоОстаткамСпецодеждаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьПоОстаткамСпецодеждаНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораПартии(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = Тип("ДокументСсылка.ПередачаМатериаловВЭксплуатацию") Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура("Организация", Объект.Организация);
		ОткрытьФорму("Документ.ПередачаМатериаловВЭксплуатацию.ФормаВыбора", ПараметрыФормы, Элемент);
	ИначеЕсли ВыбранноеЗначение = Тип("ДокументСсылка.ПартияМатериаловВЭксплуатации") Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура("Организация", Объект.Организация);
		ОткрытьФорму("Документ.ПартияМатериаловВЭксплуатации.ФормаВыбора", ПараметрыФормы, Элемент);
	КонецЕсли;
	
КонецПроцедуры

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
