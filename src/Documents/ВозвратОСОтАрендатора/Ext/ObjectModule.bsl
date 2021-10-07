﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьПереданнымиКонтрагентуОС() Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Период", Новый Граница(МоментВремени(), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
	|ИЗ
	|	РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(&Период, Организация = &Организация) КАК МестонахождениеОСБухгалтерскийУчетСрезПоследних
	|ГДЕ
	|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Контрагент = &Контрагент";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаТЧ = ОС.Добавить();
		СтрокаТЧ.ОсновноеСредство = Выборка.ОсновноеСредство;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено
			И ТипДанныхЗаполнения <> Тип("Структура")
			И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	КонецЕсли;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

	Если НЕ ЗначениеЗаполнено(СобытиеОС) Тогда
		СобытиеОС = УчетОС.ПолучитьСобытиеПоОСИзСправочника(Перечисления.ВидыСобытийОС.ВозвратОСОтАрендатора);
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ВозвратОСОтАрендатора.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	УчетОС.ПроверитьСоответствиеОСОрганизации(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты,
		Отказ);

	УчетОС.ПроверитьСостояниеОСПринятоКУчету(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты,
		Отказ);

	УчетОС.ПроверитьЗаполнениеСчетаУчетаОС(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты,
		Отказ);

	УчетОС.ПроверитьВозможностьВозвратаОСОтАрендатора(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты,
		Отказ);

	ПараметрыНачисленияАмортизации = УчетОС.ПодготовитьТаблицыАмортизацииОСИСуммАмортизационнойПремии(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты,
		Отказ);

	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ

	// Алгоритмы формирования проводок этого документа рассчитывают суммы проводок налогового учета
	Движения.Хозрасчетный.ДополнительныеСвойства.Вставить("СуммыНалоговогоУчетаЗаполнены", Истина);

	УчетОС.СформироватьДвиженияИзменениеМестонахожденияОСБУ(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.МестонахождениеОСБУ,
		Движения, Отказ);

	УчетОС.СформироватьДвиженияРегистрацияСобытияОС(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты,
		Движения, Отказ);

	УчетОС.СформироватьДвиженияНачислениеАмортизацииИАмортизационнойПремии(
		ПараметрыНачисленияАмортизации,
		Движения, Отказ);

	УчетОС.СформироватьДвиженияПеремещениеОС(
		ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.Реквизиты,
		ПараметрыНачисленияАмортизации,
		Движения, Отказ);
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	УправлениеВнеоборотнымиАктивами.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", Новый Структура("ОсновноеСредство"), Отказ);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСДоговорамиКонтрагентовБП.ЗаполнитьДоговорПередЗаписью(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДокументуОснованию(Основание)

	Если ТипЗнч(Основание) = Тип("СправочникСсылка.ОсновныеСредства") Тогда

		Если Основание.ЭтоГруппа Тогда

			ТекстСообщения = НСтр("ru = 'Ввод Возврата ОС от арендатора на основании группы ОС невозможен!
				|Выберите ОС. Для раскрытия группы используйте клавиши Ctrl и стрелку вниз'");
			ВызватьИсключение(ТекстСообщения);

		КонецЕсли;

		СтрокаТабличнойЧасти = ОС.Добавить();
		СтрокаТабличнойЧасти.ОсновноеСредство = Основание;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ЕСТЬNULL(ПервоначальныеСведенияОС.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Организация
			|ИЗ
			|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(
			|		&Дата,
			|		ОсновноеСредство = &ОсновноеСредство
			|	) КАК ПервоначальныеСведенияОС
			|";
		Запрос.УстановитьПараметр("Дата", НачалоДня(ТекущаяДатаСеанса()));
		Запрос.УстановитьПараметр("ОсновноеСредство", Основание);
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			Организация = Выборка.Организация;
		КонецЕсли;
	
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ПередачаОСВАренду") Тогда
		
		// Заполним реквизиты из стандартного набора по документу основанию.
		ДанныеОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание, 
			"ПодразделениеОрганизации, Организация, Контрагент, ДоговорКонтрагента");
		
		Организация              = ДанныеОснования.Организация;
		ПодразделениеОрганизации = ДанныеОснования.ПодразделениеОрганизации;
		Контрагент               = ДанныеОснования.Контрагент;
		ДоговорКонтрагента       = ДанныеОснования.ДоговорКонтрагента;
		ЗаполнениеДокументов.Заполнить(ЭтотОбъект);
		
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Передача", Основание);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПередачаОСВАрендуОС.НомерСтроки,
		|	ПередачаОСВАрендуОС.ОсновноеСредство
		|ИЗ
		|	Документ.ПередачаОСВАренду.ОС КАК ПередачаОСВАрендуОС
		|ГДЕ
		|	ПередачаОСВАрендуОС.Ссылка = &Передача";
		
		ТаблицаОсновныхСредств = Запрос.Выполнить().Выгрузить();
		
		ОС.Загрузить(ТаблицаОсновныхСредств);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли