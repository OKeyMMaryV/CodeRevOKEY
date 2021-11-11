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
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
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

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	УстановитьСостояниеДокумента();
	
	УстановитьЗаголовокФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Оповестить("Запись_ИзменениеУсловийАренды", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ПроцентыПоОбязательствамФормыКлиент.ОбработкаВыбора(
		ЭтотОбъект, ВыбранноеЗначение, ИсточникВыбора, "СпособОценкиАрендыБУ");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаВходящегоДокументаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДатаВходящегоДокумента) И НЕ Объект.Проведен Тогда
		Объект.Дата = Объект.ДатаВходящегоДокумента + (Объект.Дата - НачалоДня(Объект.Дата));
		ДатаПриИзмененииНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		КонтрагентПриИзмененииНаСервере();
	КонецЕсли;
	
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
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		ДоговорКонтрагентаПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияАрендыПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДатаОкончанияАренды) Тогда
		ПроверитьДатуОкончанияАренды();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СпособОценкиАрендыБУПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьГрафикПлатежейНажатие(Элемент, СтандартнаяОбработка)
	Перем ПараметрыФормы;
	
	ПроцентыПоОбязательствамФормыКлиент.ПолучитьПараметрыФормыГрафикПлатежейДляАренды(ЭтотОбъект, ПараметрыФормы);
	ПроцентыПоОбязательствамФормыКлиент.НадписьГрафикПлатежейНажатие(ЭтотОбъект, СтандартнаяОбработка, ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦеныИВалютаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработатьИзмененияПоКнопкеЦеныИВалюты();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПредметыАренды

&НаКлиенте
Процедура ПредметыАрендыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Не НоваяСтрока Или Копирование Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ПредметыАренды.ТекущиеДанные;
	
	ДанныеОбъекта = Новый Структура;
	ДанныеОбъекта.Вставить("РасчетыВУЕ", РасчетыВУЕ);
	
	СчетаУчета = СчетаУчетаПредметаАренды(ДанныеОбъекта);
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, СчетаУчета);
	
	ТекущиеДанные.СтавкаНДС = УчетНДСКлиентСервер.СтавкаНДСПоУмолчанию(Объект.Дата);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыАрендыПриИзменении(Элемент)
	
	ОбновитьИтоги(ЭтотОбъект);
	ПроцентыПоОбязательствамФормыКлиентСервер.СформироватьНадписьГрафикПлатежей(ЭтотОбъект, "СпособОценкиАрендыБУ");
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыАрендыСуммаПриИзменении(Элемент)
	
	ОбработкаТабличныхЧастейКлиентСервер.ПриИзмененииСумма(ЭтотОбъект, "ПредметыАренды");
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыАрендыСтавкаНДСПриИзменении(Элемент)
	
	ОбработкаТабличныхЧастейКлиентСервер.ПриИзмененииСтавкаНДС(ЭтотОбъект, "ПредметыАренды");
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыАрендыСуммаНДСПриИзменении(Элемент)
	
	ОбработкаТабличныхЧастейКлиентСервер.ПриИзмененииСуммаНДС(ЭтотОбъект, "ПредметыАренды");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
	УстановитьСостояниеДокумента();
	
	ТекущаяДатаДокумента = Объект.Дата;
	
	ЕстьРасширенныйФункционал = ПолучитьФункциональнуюОпцию("РасширенныйФункционал");
	ЕстьВалютныйУчет = БухгалтерскийУчетПереопределяемый.ИспользоватьВалютныйУчет();
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ПолучитьРеквизитыДоговора();
	
	Лизинг = Объект.ВидОперации = Перечисления.ВидыОперацийИзменениеУсловийАренды.ИзменениеУсловийЛизинга;
	
	ПроцентыПоОбязательствамФормыКлиентСервер.ЗаполнитьСписокВыбораСпособОценкиАрендыБУИзменение(ЭтотОбъект);
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	УстановитьЗаголовокФормы(ЭтотОбъект);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокФормы(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	НаименованиеДокумента = ?(Форма.Лизинг,
		НСтр("ru = 'Изменение условий лизинга'"),
		НСтр("ru = 'Изменение условий аренды'"));
	
	ТекстЗаголовка = ?(ЗначениеЗаполнено(Объект.Ссылка),
		СтрШаблон(НСтр("ru='%1 %2 от %3'"), НаименованиеДокумента, Объект.Номер, Объект.Дата),
		СтрШаблон(НСтр("ru='%1 (создание)'"), НаименованиеДокумента));
	
	Форма.Заголовок = ТекстЗаголовка;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтотОбъект);
	ПлательщикНДС = УчетнаяПолитика.ПлательщикНДС(Объект.Организация, Объект.Дата);
	ПлательщикНалогаНаПрибыль = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Объект.Организация, Объект.Дата);
	ПрименяетсяФСБУ25 = УчетнаяПолитика.ПрименяетсяФСБУ25(Объект.Организация, Объект.Дата);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()
	
	ПараметрыОбъекта = Новый Структура;
	ПараметрыОбъекта.Вставить("СуммаВключаетНДС", Объект.СуммаВключаетНДС);
	
	Для каждого СтрокаТаблицы Из Объект.ПредметыАренды Цикл
		ЗаполнитьДобавленныеКолонкиСтрокиТаблицы(СтрокаТаблицы, ПараметрыОбъекта);
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьДобавленныеКолонкиСтрокиТаблицы(СтрокаТаблицы, ПараметрыОбъекта)
	
	СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма + ?(ПараметрыОбъекта.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Элементы.ПодразделениеОрганизации.Доступность = ЗначениеЗаполнено(Объект.Организация);
	Элементы.ДоговорКонтрагента.Доступность = ЗначениеЗаполнено(Объект.Организация)
		И ЗначениеЗаполнено(Объект.Контрагент);
	
	Элементы.ГруппаОценкаАрендыБУ.Видимость = Форма.ЕстьРасширенныйФункционал
		И Форма.ПрименяетсяФСБУ25;
	
	ПроцентыПоОбязательствамФормыКлиентСервер.УправлениеФормойИзменение(Форма);
	
	ОбновитьИтоги(Форма);
	СформироватьНадписьЦеныИВалюта(Форма);
	ПроцентыПоОбязательствамФормыКлиентСервер.СформироватьНадписьГрафикПлатежей(Форма, "СпособОценкиАрендыБУ");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИтоги(Форма)
	
	Объект = Форма.Объект;
	Форма.Всего = Объект.ПредметыАренды.Итог("Всего");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ПроцентыПоОбязательствамФормы.УстановитьУсловноеОформление(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзмененииНаКлиенте()
	
	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;
	
	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(
		Объект.Дата, ТекущаяДатаДокумента, Объект.ВалютаДокумента, ВалютаРегламентированногоУчета);
	
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	ДатаОбработатьИзменение();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ДатаОбработатьИзменение()
	
	УстановитьФункциональныеОпцииФормы();
	
	УстановитьКурсКратность();
	
	ПроцентыПоОбязательствамФормыКлиентСервер.ЗаполнитьСписокВыбораСпособОценкиАрендыБУИзменение(ЭтотОбъект);
	ПроцентыПоОбязательствамФормыКлиентСервер.УстановитьСпособОценкиАрендыБУИзменение(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ОрганизацияОбработатьИзменение();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияОбработатьИзменение()
	
	УстановитьФункциональныеОпцииФормы();
	
	ПодразделениеПоУмолчанию = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию(
		"ОсновноеПодразделениеОрганизации");
	Если БухгалтерскийУчетПереопределяемый.ПодразделениеПринадлежитОрганизации(
		ПодразделениеПоУмолчанию, Объект.Организация) Тогда
		Объект.ПодразделениеОрганизации = ПодразделениеПоУмолчанию;
	КонецЕсли;
	
	Объект.НДСВключенВСтоимость = НЕ ПлательщикНДС;
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		КонтрагентОбработатьИзменение();
	КонецЕсли;
	
	ПроцентыПоОбязательствамФормыКлиентСервер.ЗаполнитьСписокВыбораСпособОценкиАрендыБУИзменение(ЭтотОбъект);
	ПроцентыПоОбязательствамФормыКлиентСервер.УстановитьСпособОценкиАрендыБУИзменение(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере()
	
	КонтрагентОбработатьИзменение();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентОбработатьИзменение()
	
	РаботаСДоговорамиКонтрагентовБП.УстановитьДоговорКонтрагента(
		Объект.ДоговорКонтрагента, Объект.Контрагент, Объект.Организация, 
		БухгалтерскийУчетПереопределяемый.ПолучитьМассивВидовДоговоров(Истина));
		
	ДоговорКонтрагентаОбработатьИзменение();
	
КонецПроцедуры

&НаСервере
Процедура ДоговорКонтрагентаПриИзмененииНаСервере()
	
	ДоговорКонтрагентаОбработатьИзменение();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ДоговорКонтрагентаОбработатьИзменение()
	
	ПараметрыСтарогоКурса = ПараметрыКурсаВалюты(ЭтотОбъект);
	
	ПолучитьРеквизитыДоговора();
	
	Объект.ВалютаДокумента = ВалютаВзаиморасчетов;
	УстановитьКурсКратность();
	
	ПараметрыНовогоКурса = ПараметрыКурсаВалюты(ЭтотОбъект);
	ЗаполнитьРассчитатьСуммы(ПараметрыСтарогоКурса, ПараметрыНовогоКурса);
	
	Если РасчетыВУЕ Тогда
		Объект.СчетУчетаРасчетовСКонтрагентом = ПланыСчетов.Хозрасчетный.АрендныеОбязательстваУЕ;
	ИначеЕсли Объект.ВалютаДокумента <> ВалютаРегламентированногоУчета Тогда
		Объект.СчетУчетаРасчетовСКонтрагентом = ПланыСчетов.Хозрасчетный.АрендныеОбязательстваВал;
	Иначе
		Объект.СчетУчетаРасчетовСКонтрагентом = ПланыСчетов.Хозрасчетный.АрендныеОбязательства;
	КонецЕсли;
	
	ЗаполнитьСчетаУчетаПредметовАренды(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРассчитатьСуммы(ПараметрыСтарогоКурса, ПараметрыНовогоКурса)
	
	Для каждого СтрокаТаблицы Из Объект.ПредметыАренды Цикл
		ЗаполнитьРассчитатьСуммыВСтроке(СтрокаТаблицы, ПараметрыСтарогоКурса, ПараметрыНовогоКурса);
	КонецЦикла;
	
	ПроцентыПоОбязательствамФормы.ЗаполнитьРассчитатьСуммы(
		ЭтотОбъект, ПараметрыСтарогоКурса, ПараметрыНовогоКурса, "ПредметыАренды");
	
	ОбновитьИтоги(ЭтотОбъект);
	ПроцентыПоОбязательствамФормыКлиентСервер.СформироватьНадписьГрафикПлатежей(ЭтотОбъект, "СпособОценкиАрендыБУ");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРассчитатьСуммыВСтроке(СтрокаТаблицы, ПараметрыТекущегоКурса, ПараметрыНовогоКурса)
	
	СтрокаТаблицы.Сумма = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
		СтрокаТаблицы.Сумма, ПараметрыТекущегоКурса, ПараметрыНовогоКурса);
	
	СтавкаНДС = УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТаблицы.СтавкаНДС);
	СтрокаТаблицы.СуммаНДС = УчетНДСКлиентСервер.РассчитатьСуммуНДС(
		СтрокаТаблицы.Сумма, Объект.СуммаВключаетНДС, СтавкаНДС);
	
	СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма 
		+ ?(Объект.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзмененияПоКнопкеЦеныИВалюты()
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ВалютаДокумента", Объект.ВалютаДокумента);
	СтруктураПараметров.Вставить("Курс", Объект.КурсВзаиморасчетов);
	СтруктураПараметров.Вставить("Кратность", Объект.КратностьВзаиморасчетов);
	СтруктураПараметров.Вставить("Контрагент", Объект.Контрагент);
	СтруктураПараметров.Вставить("Договор", Объект.ДоговорКонтрагента);
	СтруктураПараметров.Вставить("Организация", Объект.Организация);
	СтруктураПараметров.Вставить("ДатаДокумента", Объект.Дата);
	СтруктураПараметров.Вставить("СуммаВключаетНДС", Объект.СуммаВключаетНДС);
	СтруктураПараметров.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	
	ДополнительныеПараметры = Новый Структура;
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбработатьИзмененияПоКнопкеЦеныИВалютыЗавершение", 
		ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ФормаЦеныИВалюта", СтруктураПараметров,,,,,ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзмененияПоКнопкеЦеныИВалютыЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.Свойство("СтруктураПараметровКоманды") Тогда
		
		Если РезультатЗакрытия = Неопределено Тогда 
			Возврат;
		КонецЕсли;
		
		СтруктураЦеныИВалюта = ДополнительныеПараметры.СтруктураПараметровКоманды;
		
		СуммаВключаетНДСДоИзменения = СтруктураЦеныИВалюта.СуммаВключаетНДС;
		
		СтруктураЦеныИВалюта.СуммаВключаетНДС = 
			РезультатЗакрытия.Значение = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.НДСВСумме");
		СтруктураЦеныИВалюта.Вставить("БылиВнесеныИзменения", 
			СуммаВключаетНДСДоИзменения <> СтруктураЦеныИВалюта.СуммаВключаетНДС);
		
	Иначе
		
		СтруктураЦеныИВалюта = РезультатЗакрытия;
		
	КонецЕсли;
	
	Если ТипЗнч(СтруктураЦеныИВалюта) = Тип("Структура") И СтруктураЦеныИВалюта.БылиВнесеныИзменения Тогда
		
		ПараметрыТекущегоКурса = ПараметрыКурсаВалюты(ЭтотОбъект);
		
		Объект.ВалютаДокумента = СтруктураЦеныИВалюта.ВалютаДокумента;
		Объект.КурсВзаиморасчетов = СтруктураЦеныИВалюта.КурсРасчетов;
		Объект.КратностьВзаиморасчетов = СтруктураЦеныИВалюта.КратностьРасчетов;
		
		ПараметрыНовогоКурса = ПараметрыКурсаВалюты(ЭтотОбъект);
		
		Объект.СуммаВключаетНДС = СтруктураЦеныИВалюта.СуммаВключаетНДС;
		Объект.НДСВключенВСтоимость = СтруктураЦеныИВалюта.НДСВключенВСтоимость;
		
		Модифицированность = Истина;
		
		ЗаполнитьРассчитатьСуммы(ПараметрыТекущегоКурса, ПараметрыНовогоКурса);
		
		СформироватьНадписьЦеныИВалюта(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыКурсаВалюты(Форма)
	
	Объект = Форма.Объект;
	
	ПараметрыКурса = Новый Структура("Валюта,Курс,Кратность");
	
	ПараметрыКурса.Валюта = Объект.ВалютаДокумента;
	ПараметрыКурса.Курс = ?(Объект.ВалютаДокумента = Форма.ВалютаРегламентированногоУчета, 
		1, Объект.КурсВзаиморасчетов);
	ПараметрыКурса.Кратность = ?(Объект.ВалютаДокумента = Форма.ВалютаРегламентированногоУчета, 
		1, Объект.КратностьВзаиморасчетов);
	
	Возврат ПараметрыКурса;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьНадписьЦеныИВалюта(Форма)
	
	Объект = Форма.Объект;
	СтруктураНадписи = Новый Структура;
	СтруктураНадписи.Вставить("ВалютаДокумента", Объект.ВалютаДокумента);
	СтруктураНадписи.Вставить("Курс", Объект.КурсВзаиморасчетов);
	СтруктураНадписи.Вставить("Кратность", Объект.КратностьВзаиморасчетов);
	СтруктураНадписи.Вставить("СуммаВключаетНДС", Объект.СуммаВключаетНДС);
	СтруктураНадписи.Вставить("ВалютаРегламентированногоУчета", Форма.ВалютаРегламентированногоУчета);
	СтруктураНадписи.Вставить("НДСВключенВСтоимость", Объект.НДСВключенВСтоимость);
	
	Форма.ЦеныИВалюта = ОбщегоНазначенияБПКлиентСервер.СформироватьНадписьЦеныИВалюта(СтруктураНадписи);
	
КонецПроцедуры 

&НаКлиенте
Функция ПроверитьДатуОкончанияАренды() Экспорт
	
	Если Не ЗначениеЗаполнено(Объект.ДатаОкончанияАренды) Тогда
		ТекстСообщения = НСтр("ru='Не заполнена дата окончания аренды.'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат Ложь;
	ИначеЕсли Объект.ДатаОкончанияАренды < НачалоДня(Объект.Дата) Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru='Дата окончания аренды должна быть не ранее %1.'"),
			Формат(Объект.Дата, "ДЛФ=D"));
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСчетаУчетаПредметовАренды(Форма)
	
	Объект = Форма.Объект;
	
	ДанныеОбъекта = Новый Структура;
	ДанныеОбъекта.Вставить("РасчетыВУЕ", Форма.РасчетыВУЕ);
	
	СчетаУчета = СчетаУчетаПредметаАренды(ДанныеОбъекта);
	
	Для каждого СтрокаТаблицы Из Объект.ПредметыАренды Цикл
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СчетаУчета);
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СчетаУчетаПредметаАренды(ДанныеОбъекта)
	
	СчетаУчета = Документы.ИзменениеУсловийАренды.СчетаУчетаПредметаАренды(ДанныеОбъекта);
	Возврат СчетаУчета;
	
КонецФункции

&НаСервере
Процедура ПолучитьРеквизитыДоговора()
	
	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Объект.ДоговорКонтрагента, "ВалютаВзаиморасчетов,РасчетыВУсловныхЕдиницах");
		РасчетыВУЕ = РеквизитыДоговора.РасчетыВУсловныхЕдиницах;
		ВалютаВзаиморасчетов = РеквизитыДоговора.ВалютаВзаиморасчетов;
	Иначе
		РасчетыВУЕ = Ложь;
		ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКурсКратность()
	
	Если ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета Тогда
		Объект.КурсВзаиморасчетов = 1;
		Объект.КратностьВзаиморасчетов = 1;
	Иначе
		СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаВзаиморасчетов, Объект.Дата);
		Объект.КурсВзаиморасчетов = СтруктураКурса.Курс;
		Объект.КратностьВзаиморасчетов = СтруктураКурса.Кратность;
	КонецЕсли;
	
КонецПроцедуры 

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

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


