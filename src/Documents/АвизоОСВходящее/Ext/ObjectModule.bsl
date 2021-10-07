﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	КонецЕсли;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	ПараметрыПроведения = Документы.АвизоОСВходящее.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	// Алгоритмы формирования проводок этого документа рассчитывают суммы проводок налогового учета
	Движения.Хозрасчетный.ДополнительныеСвойства.Вставить("СуммыНалоговогоУчетаЗаполнены", Истина);
	
	Документы.АвизоОСВходящее.СформироватьДвиженияСтоимостьОС(
		ПараметрыПроведения.ТаблицаСтоимостьОС,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	Документы.АвизоОСВходящее.СформироватьДвиженияНакопленнаяАмортизация(
		ПараметрыПроведения.ТаблицаНакопленнаяАмортизация,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	Документы.АвизоОСВходящее.СформироватьДвиженияНакопленныйИзнос(
		ПараметрыПроведения.ТаблицаНакопленныйИзнос,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	Документы.АвизоОСВходящее.СформироватьДвиженияПервоначальныеСведенияОСБух(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	Документы.АвизоОСВходящее.СформироватьДвиженияМестонахождениеОСБух(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	Документы.АвизоОСВходящее.СформироватьДвиженияПараметрыАмортизацииБух(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
 	Документы.АвизоОСВходящее.СформироватьДвиженияНачислениеАмортизацииБух(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
 	Документы.АвизоОСВходящее.СформироватьДвиженияСпособыОтраженияРасходовПоАмортизацииБух(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

 	Документы.АвизоОСВходящее.СформироватьДвиженияГрафикиАмортизацииОСБух(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

 	Документы.АвизоОСВходящее.СформироватьДвиженияСчетовУчетаОСБух(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

 	Документы.АвизоОСВходящее.СформироватьДвиженияСостоянияОСБух(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

 	Документы.АвизоОСВходящее.СформироватьДвиженияСобытияОСОрганизаций(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	Документы.АвизоОСВходящее.СформироватьДвиженияПервоначальныеСведенияОСНал(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	Документы.АвизоОСВходящее.СформироватьДвиженияПараметрыАмортизацииНал(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	Документы.АвизоОСВходящее.СформироватьДвиженияНачислениеАмортизацииНал(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	Документы.АвизоОСВходящее.СформироватьДвиженияСпецКоэффициентНал(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	Документы.АвизоОСВходящее.СформироватьДвиженияСпособыОтраженияРасходовПоАренднымПлатежамНал(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	Документы.АвизоОСВходящее.СформироватьДвиженияПервоначальныеСведенияОСУСН(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	//организация и отправитель должны отличаться
	Если Организация = ОрганизацияОтправитель Тогда
		ТекстСообщения = НСтр("ru = 'Отправитель должен отличаться от получателя.'");
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Корректность", 
																НСтр("ru = 'Отправитель'"),,, ТекстСообщения);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ОрганизацияОтправитель", "Объект", Отказ);
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	// Проверим, нет ли повторяющихся основных средств в таблице по ОС.
	УправлениеВнеоборотнымиАктивами.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", Новый Структура("ОсновноеСредство"), Отказ);
	
	// Проверка табличной части "ОС"
	МассивНепроверяемыхРеквизитов.Добавить("ОС.ОсновноеСредство");
	МассивНепроверяемыхРеквизитов.Добавить("ОС.ИнвентарныйНомер");
	МассивНепроверяемыхРеквизитов.Добавить("ОС.СчетУчета");
	МассивНепроверяемыхРеквизитов.Добавить("ОС.ДатаПринятияКУчету");
	МассивНепроверяемыхРеквизитов.Добавить("ОС.ПорядокПогашенияСтоимости");
	
	Для каждого СтрокаТаблицы Из ОС Цикл
		
		Префикс 	= "ОС[" + Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
		Поле 		= Префикс + "ОсновноеСредство";
		ИмяСписка 	= НСтр("ru = 'Основные средства'");
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ОсновноеСредство) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Основное средство'"),
				СтрокаТаблицы.НомерСтроки, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ИнвентарныйНомер) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Инвентарный номер'"),
				СтрокаТаблицы.НомерСтроки, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.СчетУчета) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Счет учета'"),
				СтрокаТаблицы.НомерСтроки, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДатаПринятияКУчету) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Дата принятия к учету'"),
				СтрокаТаблицы.НомерСтроки, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;

		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ПорядокПогашенияСтоимости) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Порядок погашения стоимости'"),
				СтрокаТаблицы.НомерСтроки, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
 		
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДокументуОснованию(Основание)
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.АвизоОСИсходящее") Тогда
		
		// Заполним реквизиты из стандартного набора по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);

		Документы.АвизоОСВходящее.ЗаполнитьПоАвизоОСИсходящее(ЭтотОбъект, Основание);
		
	КонецЕсли;
   	
КонецПроцедуры

#КонецОбласти

#КонецЕсли