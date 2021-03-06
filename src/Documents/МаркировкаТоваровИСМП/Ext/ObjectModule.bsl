#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияИСМППереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
	ЗаполнитьОбъектПоСтатистике();
	
	Если Операция <> Перечисления.ВидыОперацийИСМП.ВводВОборотПроизводствоВнеЕАЭС Тогда
		ИнтеграцияИСМППереопределяемый.ЗаполнитьКодыТНВЭДПоНоменклатуреВТабличнойЧасти(Товары);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	// Обувная продукция
	НепроверяемыеРеквизиты.Добавить("ПринятоеРешение");
	НепроверяемыеРеквизиты.Добавить("КодТаможенногоОргана");
	НепроверяемыеРеквизиты.Добавить("СтранаПроисхождения");
	НепроверяемыеРеквизиты.Добавить("ДатаДекларации");
	НепроверяемыеРеквизиты.Добавить("РегистрационныйНомерДекларации");
	НепроверяемыеРеквизиты.Добавить("Контрагент");
	НепроверяемыеРеквизиты.Добавить("ДатаПроизводства");
	НепроверяемыеРеквизиты.Добавить("ДатаИмпорта");
	НепроверяемыеРеквизиты.Добавить("ДатаПервичногоДокумента");
	НепроверяемыеРеквизиты.Добавить("НомерПервичногоДокумента");
	НепроверяемыеРеквизиты.Добавить("Товары.Цена");
	НепроверяемыеРеквизиты.Добавить("Товары.СуммаНДС");
	
	// Табачная продукция
	НепроверяемыеРеквизиты.Добавить("ИдентификаторПроизводственнойЛинии");
	
	ОбязательныеРеквизиты = Новый Массив;
	Если ВидПродукции = Перечисления.ВидыПродукцииИС.Обувная Тогда
		Если Операция = Перечисления.ВидыОперацийИСМП.ВводВОборотПроизводствоВнеЕАЭС Тогда
			ОбязательныеРеквизиты.Добавить("ПринятоеРешение");
			ОбязательныеРеквизиты.Добавить("КодТаможенногоОргана");
			ОбязательныеРеквизиты.Добавить("СтранаПроисхождения");
			ОбязательныеРеквизиты.Добавить("ДатаДекларации");
			ОбязательныеРеквизиты.Добавить("РегистрационныйНомерДекларации");
		ИначеЕсли Операция = Перечисления.ВидыОперацийИСМП.ВводВОборотПроизводствоРФПоДоговору
			Или Операция = Перечисления.ВидыОперацийИСМП.ВводВОборотПроизводствоРФПоДоговоруНаСторонеЗаказчика Тогда
			ОбязательныеРеквизиты.Добавить("Контрагент");
			ОбязательныеРеквизиты.Добавить("ДатаПроизводства");
		ИначеЕсли Операция = Перечисления.ВидыОперацийИСМП.ВводВОборотПроизводствоРФ Тогда
			ОбязательныеРеквизиты.Добавить("ДатаПроизводства");
		ИначеЕсли Операция = Перечисления.ВидыОперацийИСМП.ВводВОборотТрансграничнаяТорговля Тогда
			ОбязательныеРеквизиты.Добавить("СтранаПроисхождения");
			ОбязательныеРеквизиты.Добавить("ДатаИмпорта");
			ОбязательныеРеквизиты.Добавить("ДатаПервичногоДокумента");
			ОбязательныеРеквизиты.Добавить("НомерПервичногоДокумента");
			ОбязательныеРеквизиты.Добавить("Контрагент");
			ОбязательныеРеквизиты.Добавить("Товары.Цена");
			ОбязательныеРеквизиты.Добавить("Товары.СуммаНДС");
		КонецЕсли;
	ИначеЕсли ВидПродукции = Перечисления.ВидыПродукцииИС.Табачная Тогда
		ОбязательныеРеквизиты.Добавить("ИдентификаторПроизводственнойЛинии");
	КонецЕсли;
	
	ИнтеграцияИСМППереопределяемый.ПриОпределенииОбработкиПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	Если Операция = Перечисления.ВидыОперацийИСМП.ВводВОборотМаркировкаОстатков Тогда
		НепроверяемыеРеквизиты.Добавить("Товары.КодТНВЭД");
	КонецЕсли;

	НепроверяемыеРеквизиты = ОбщегоНазначенияКлиентСервер.РазностьМассивов(НепроверяемыеРеквизиты, ОбязательныеРеквизиты);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	ИнтеграцияИСМПСлужебный.ПроверитьЗаполнениеШтрихкодовУпаковок(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование = Неопределено;
	ШтрихкодыУпаковок.Очистить();
	ИдентификаторПроизводственногоЗаказа = "";
	ИдентификаторПроизводственнойЛинии   = "";
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияИСМП.ЗаписатьСтатусДокументаИСМППоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаЗаполнения

Процедура ЗаполнитьОбъектПоСтатистике()
	
	ДанныеСтатистики = ЗаполнениеОбъектовПоСтатистикеИСМП.ДанныеЗаполненияМаркировкиТоваровИСМП(Организация);
	
	Для Каждого КлючИЗначение Из ДанныеСтатистики Цикл
		ЗаполнениеОбъектовПоСтатистикеИСМП.ЗаполнитьПустойРеквизит(ЭтотОбъект, ДанныеСтатистики, КлючИЗначение.Ключ);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли