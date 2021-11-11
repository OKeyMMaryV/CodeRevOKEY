﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяВзноса   = Параметры.ИмяВзноса;
	ВидВзноса   = Параметры.ВидВзноса;
	Всего       = Параметры.Всего;
	Начислено   = Параметры.Начислено;
	Уплачено    = Параметры.Уплачено;
	Переплата   = Параметры.Переплата;
	Сумма       = Параметры.Сумма;
	Организация = Параметры.Организация;
	Период      = Параметры.Период;
	
	ТаблицаПлатежей = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыПлатежей);
	Если ТипЗнч(ТаблицаПлатежей) = Тип("ТаблицаЗначений") Тогда
		Платежи.Загрузить(ТаблицаПлатежей);
		Для Каждого Платеж Из Платежи Цикл
			Платеж.ПредставлениеДокумента = ПомощникиПоУплатеНалоговИВзносов.ПредставлениеДокументаОплаты(Платеж, Истина);
		КонецЦикла;
	КонецЕсли;
	
	ПомощникиПоУплатеНалоговИВзносов.ОтобразитьПлатежиССуммойВОтдельнойКолонке(ЭтотОбъект, Платежи, "Платеж");
	
	ИспользуетсяИнтеграцияСБанком = ОбщегоНазначенияБП.ЭтоИнтерфейсИнтеграцииСБанком();
	
	Заголовок = Параметры.Заголовок;
	
	Элементы.ЗаголовокКОплате.Заголовок = СтрШаблон(НСтр("ru = 'К оплате за %1 квартал'"), Формат(Период, "ДФ=к"));
	
	УправлениеФормойНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		Если ЗавершениеРаботы Тогда
			Возврат;
		КонецЕсли;
		
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если ИзмененаПереплата Тогда
			ИзменитьОстаткиРасчетовПоВзносуВФоне(Организация, Период, ВидВзноса, Переплата);
		КонецЕсли;
		
		ОповеститьОВыбореИЗакрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеВыписки" 
		ИЛИ ИмяСобытия = "ОбновитьПоказателиРасчетаУСН" И Не ЗначениеЗаполнено(Параметр) Тогда
		
		ЗаполнитьСтраховыеВзносыНаСервере();
		
	ИначеЕсли ИмяСобытия = "Запись_ПлатежныйДокумент_УплатаНалогов" Тогда
		
		Налог = Неопределено;
		
		Если ТипЗнч(Параметр) = Тип("Структура")
			И Параметр.Свойство("Организация") И Параметр.Организация = Организация
			И Параметр.Свойство("Налог", Налог) И ЗначениеЗаполнено(Налог)
			И Параметр.Свойство("Оплачено") И Параметр.Оплачено = Истина
			И ЭтоФиксированныеВзносы(Налог) Тогда
			
			ЗаполнитьСтраховыеВзносыНаСервере();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_ПлатежОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыПлатежныхДокументов = ПомощникиПоУплатеНалоговИВзносовКлиент.ПараметрыОбработкиПлатежныхДокументов(
		Платежи, "Платеж", ОповещениеУдаленияПлатежногоДокумента());
	
	ПомощникиПоУплатеНалоговИВзносовКлиент.ОбработкаНавигационнойСсылкиПлатежногоДокумента(Элемент, НавигационнаяСсылкаФорматированнойСтроки, ПараметрыПлатежныхДокументов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереплатаПриИзменении(Элемент)
	ИзмененаПереплата = Истина;
	РассчитатьСуммуКУплате(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьОплатуЧерезБанк(Команда)
	
	Перем ВидНалога, БанковскийСчет;
	
	ВидНалога = ВидНалогаПоИмениВзноса();
	
	Если ИспользуетсяИнтеграцияСБанком Тогда
		БанковскийСчет = ПредопределенноеЗначение("Справочник.БанковскиеСчета.ПустаяСсылка");
	КонецЕсли;
	
	ПомощникиПоУплатеНалоговИВзносовКлиент.СоздатьОплатуЧерезБанк(
		Организация,
		Период,
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВидНалога),
		ПредопределенноеЗначение("Перечисление.ВидыПлатежейВГосБюджет.Налог"),
		БанковскийСчет);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьОплатуНаличными(Команда)
	
	ПомощникиПоУплатеНалоговИВзносовКлиент.СоздатьОплатуНаличными(
		Организация,
		Период,
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВидНалогаПоИмениВзноса()),
		ПредопределенноеЗначение("Перечисление.ВидыПлатежейВГосБюджет.Налог"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если ИзмененаПереплата Тогда
		ИзмененаПереплата = Ложь;
		ИзменитьОстаткиРасчетовПоВзносуВФоне(Организация, Период, ВидВзноса, Переплата);
	КонецЕсли;
	
	ОповеститьОВыбореИЗакрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормойНаСервере()
	
	ПоказыватьПереплату = ПомощникиПоУплатеНалоговИВзносов.ПоказыватьПереплатуПоНалогуВзносу(Организация, Период);
	
	Элементы.ГруппаПереплата.Видимость = ПоказыватьПереплату;
	Элементы.ЗаголовокПереплата.Заголовок = СтрШаблон(НСтр("ru = 'Переплата на %1'"), Формат(НачалоГода(Период), "ДЛФ=D"));
	
	Если ПоказыватьПереплату Тогда
		Элементы.ЗаголовокУплачено.Заголовок = СтрШаблон(НСтр("ru = 'Уплачено с %1 г.'"), Формат(НачалоГода(Период), "ДЛФ=D"));
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = ИмяВзноса + Платежи.Количество();
	
	Если ОбщегоНазначенияБП.ЭтоИнтерфейсИнтеграцииСБанком() Тогда
		КлючСохраненияПоложенияОкна = КлючСохраненияПоложенияОкна + "ИнтеграцияСБанком";
	КонецЕсли;
	
	Если ПоказыватьПереплату Тогда
		КлючСохраненияПоложенияОкна = КлючСохраненияПоложенияОкна + "ПоказыватьПереплату";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОВыбореИЗакрыть()
	
	Модифицированность = Ложь;
	
	Результат = Новый Структура;
	Результат.Вставить(ИмяВзноса, Сумма);
	Результат.Вставить(ИмяВзноса + "Переплата", Переплата);
	
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры

&НаКлиенте
Функция ВидНалогаПоИмениВзноса()
	
	Если ИмяВзноса = "СуммаВзносаПФР" Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыНалогов.ФиксированныеВзносы_ПФР_СтраховаяЧасть");
	ИначеЕсли ИмяВзноса = "СуммаВзносаФФОМС" Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыНалогов.ФиксированныеВзносы_ФФОМС");
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ОповещениеУдаленияПлатежногоДокумента()
	Возврат Новый ОписаниеОповещения("УдалитьДокументУплатыНаКлиентеЗавершение", ЭтотОбъект);
КонецФункции

&НаКлиенте
Процедура УдалитьДокументУплатыНаКлиентеЗавершение(ДокументУплатыДляУдаления, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ДокументУплатыДляУдаления) Тогда
		УдалитьДокументУплаты(ДокументУплатыДляУдаления);
		Оповестить("УдалитьДокументУплаты", ДокументУплатыДляУдаления);
		Оповестить("ОбновитьПоказателиРасчетаУСН", , ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьДокументУплаты(ДокументУплатыДляУдаления)
	
	ДокументУплатыОбъект = ДокументУплатыДляУдаления.ПолучитьОбъект();
	ДокументУплатыОбъект.УстановитьПометкуУдаления(Истина);
	
	УдалитьДокументУплатыИзТаблицыПлатежей(ДокументУплатыДляУдаления);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьДокументУплатыИзТаблицыПлатежей(ДокументУплатыДляУдаления)
	
	СтрокиПлатежа = Платежи.НайтиСтроки(Новый Структура("Ссылка", ДокументУплатыДляУдаления));
	Для Каждого СтрокаПлатежа Из СтрокиПлатежа Цикл
		Уплачено = Уплачено - СтрокаПлатежа.Сумма;
		РассчитатьСуммуКУплате(ЭтотОбъект);
		Платежи.Удалить(СтрокаПлатежа);
	КонецЦикла;
	
	ПомощникиПоУплатеНалоговИВзносов.ОтобразитьПлатежиССуммойВОтдельнойКолонке(ЭтотОбъект, Платежи, "Платеж");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтраховыеВзносыНаСервере()
	
	Периодичность = УчетСтраховыхВзносовИП.ПериодичностьУплатыФиксированныхСтраховыхВзносов(Организация, Период);
	
	ФиксированныеСтраховыеВзносыКУплате = УчетСтраховыхВзносовИП.ФиксированныеСтраховыеВзносыКУплате(
		Организация, Период, Периодичность, Ложь);

	Всего     = ФиксированныеСтраховыеВзносыКУплате[ИмяВзноса + "Всего"];
	Уплачено  = ФиксированныеСтраховыеВзносыКУплате[ИмяВзноса + "Уплачено"];
	Переплата = ФиксированныеСтраховыеВзносыКУплате[ИмяВзноса + "Переплата"];
	Сумма     = ФиксированныеСтраховыеВзносыКУплате[ИмяВзноса];
	
	СтраховыеВзносыУплаченные = ФиксированныеСтраховыеВзносыКУплате.СтраховыеВзносыУплаченные;
	
	СчетаУчетаСтраховыхВзносов = УчетСтраховыхВзносовИП.СчетаУчетаСтраховыхВзносов();
	СчетУчета = СчетаУчетаСтраховыхВзносов[Сред(ИмяВзноса, 12)];
	ПараметрыОтбора = Новый Структура("СчетУчета", СчетУчета);
	
	ТаблицаПлатежей = СтраховыеВзносыУплаченные.Скопировать(СтраховыеВзносыУплаченные.НайтиСтроки(ПараметрыОтбора));
	ТаблицаПлатежей.Сортировать("ДатаДокументаОплаты, ДокументОплаты", Новый СравнениеЗначений);
	Если ТаблицаПлатежей <> Неопределено Тогда
		ТаблицаПлатежей.Колонки.ДокументОплаты.Имя = "Ссылка";
		ТаблицаПлатежей.Колонки.НомерДокументаОплаты.Имя = "Номер";
		ТаблицаПлатежей.Колонки.ДатаДокументаОплаты.Имя = "Дата";
		Платежи.Загрузить(ТаблицаПлатежей);
		Для Каждого Платеж Из Платежи Цикл
			Платеж.ПредставлениеДокумента = ПомощникиПоУплатеНалоговИВзносов.ПредставлениеДокументаОплаты(Платеж, Истина);
		КонецЦикла;
	КонецЕсли;
	
	ПомощникиПоУплатеНалоговИВзносов.ОтобразитьПлатежиССуммойВОтдельнойКолонке(ЭтотОбъект, Платежи, "Платеж");
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИзменитьОстаткиРасчетовПоВзносуВФоне(Организация, Период, ВидВзноса, Переплата)
	
	СчетУчета = Неопределено;
	Если НЕ УчетСтраховыхВзносовИП.СчетаУчетаСтраховыхВзносов().Свойство(ВидВзноса, СчетУчета) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗадания = ПомощникиПоУплатеНалоговИВзносов.НовыеПараметрыИзмененияОстатковРасчетовПоНалогамВзносамИП();
	ПараметрыЗадания.Организация       = Организация;
	ПараметрыЗадания.ПериодСобытия     = Период;
	ПараметрыЗадания.ТаблицаОстатков   = ТаблицаПереплатыПоВзносу(Организация, Период, ВидВзноса, СчетУчета, Переплата);
	ПараметрыЗадания.Комментарий = СтрШаблон(
		НСтр("ru = '#Создан автоматически обработкой ""Уплата фиксированных страховых взносов"" для отражения переплаты по взносу %1'"),
		ВидВзноса);
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.ОжидатьЗавершение = 0;
	ПараметрыВыполненияВФоне.ЗапуститьВФоне    = Истина;
	
	ДлительныеОперации.ВыполнитьВФоне("ПомощникиПоУплатеНалоговИВзносов.СохранитьПереплатуПоНалогамВзносамИнтеграцияСБанком", 
		ПараметрыЗадания, ПараметрыВыполненияВФоне);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТаблицаПереплатыПоВзносу(Организация, Период, ВидВзноса, СчетУчета, Переплата)
	
	ТаблицаОстатков = ПомощникиПоУплатеНалоговИВзносов.НоваяТаблицаИзмененияРасчетовПоНалогамВзносамИП();
	
	СтрокаОстаток = ТаблицаОстатков.Добавить();
	СтрокаОстаток.СчетУчета = СчетУчета;
	СтрокаОстаток.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Налог;
	СтрокаОстаток.Переплата = Переплата;
	
	ОстаткиРасчетов = УчетСтраховыхВзносовИП.ОстатокРасчетовПоВзносамЗаПредыдущиеСтраховыеПериодыИнтеграцияСБанком(Организация, Период);
	СтрокаОстаток.СуммаИзмененияПереплаты = Переплата - ОстаткиРасчетов[ВидВзноса];
	
	Возврат ТаблицаОстатков;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьСуммуКУплате(Форма)
	
	Форма.Сумма = Макс(Форма.Начислено - Форма.Переплата - Форма.Уплачено, 0);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоФиксированныеВзносы(Знач Налог)
	
	Возврат Обработки.РасчетСтраховыхВзносовИП.ЭтоФиксированныеВзносы(Налог);
	
КонецФункции

#КонецОбласти