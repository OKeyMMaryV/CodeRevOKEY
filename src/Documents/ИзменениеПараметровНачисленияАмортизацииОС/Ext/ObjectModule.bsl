﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	Иначе
		ОтражатьВБухгалтерскомУчете = Истина;
	КонецЕсли;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ИзменениеПараметровНачисленияАмортизацииОС.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	УчетОС.ПроверитьСоответствиеОСОрганизации(ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.ПроверкиПоОС, Отказ);

	УчетОС.ПроверитьСостояниеОСПринятоКУчету(ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.ПроверкиПоОС, Отказ);

	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	// Если ОтражатьВБухгалтерскомУчете = Ложь, то таблица ПараметровАмортизацииОСБУТаблица будет пустая
	УчетОС.СформироватьДвиженияИзмененияПараметровАмортизацииОСБУ(
		ПараметрыПроведения.ПараметровАмортизацииОСБУТаблица,
		ПараметрыПроведения.ПараметровАмортизацииОСБУ,
		Движения, Отказ);

	// Если ОтражатьВНалоговомУчете = Ложь, то таблица ПараметровАмортизацииОСНУТаблица будет пустая
	УчетОС.СформироватьДвиженияИзменениеПараметровАмортизацииОСНУ(
		ПараметрыПроведения.ПараметровАмортизацииОСНУТаблица,
		ПараметрыПроведения.ПараметровАмортизацииОСНУ,
		Движения, Отказ);

	УчетОС.СформироватьДвиженияРегистрацияСобытияОС(
		ПараметрыПроведения.СобытияОСТаблица,
		ПараметрыПроведения.СобытияОС,
		Движения, Отказ);
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если НЕ ОтражатьВБухгалтерскомУчете И НЕ ОтражатьВНалоговомУчете Тогда
		ТекстСообщения = НСтр("ru = 'Документ должен отражаться в бухгалтерском или налоговом учете.'");
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Корректность", НСтр("ru = 'Отражать в бух. / налог. учете'"), , , ТекстСообщения );
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ОтражатьВБухгалтерскомУчете", , Отказ);
	КонецЕсли;

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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДокументуОснованию(Основание)

	// Заполним реквизиты из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);

	Если ТипЗнч(Основание) = Тип("СправочникСсылка.ОсновныеСредства") Тогда
		Если Основание.ЭтоГруппа Тогда
			ТекстСообщения = НСтр("ru = 'Ввод изменения состояния ОС на основании группы ОС невозможен!
				|Выберите ОС. Для раскрытия группы используйте клавиши Ctrl и стрелку вниз'");
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;

		СтрокаТабличнойЧасти = ОС.Добавить();
		СтрокаТабличнойЧасти.ОсновноеСредство = Основание.Ссылка;

	КонецЕсли;

	ОтражатьВБухгалтерскомУчете = Истина;

	Если НЕ ЗначениеЗаполнено(СобытиеОС) Тогда
		СобытиеОС = УчетОС.ПолучитьСобытиеПоОСИзСправочника(Перечисления.ВидыСобытийОС.ВводВЭксплуатацию);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли