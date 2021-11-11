﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено
			И ТипДанныхЗаполнения <> Тип("Структура")
			И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	КонецЕсли;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-26 (#4405)
	//ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения, Истина);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-26 (#4405)

	Если НЕ ЗначениеЗаполнено(СобытиеОС) Тогда
		СобытиеОС = УчетОС.ПолучитьСобытиеПоОСИзСправочника(Перечисления.ВидыСобытийОС.Списание);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(СчетСписания) Тогда
		СчетСписания = ПланыСчетов.Хозрасчетный.ПрочиеРасходы;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.СписаниеОС.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-18 (#4405)
	Документы.СписаниеОС.ДобавитьКолонкуСодержание(ПараметрыПроведения.ОприходованиеТоваровТаблицаТовары);
	Документы.СписаниеОС.ДобавитьКолонкуСодержание(ПараметрыПроведения.НомераГТД);
	
	Документы.СписаниеОС.ДобавитьКолонкуСодержаниеУСН(ПараметрыПроведения.РеквизитыУСН);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-18 (#4405)
	
	// Алгоритмы формирования проводок этого документа рассчитывают суммы проводок налогового учета
	Движения.Хозрасчетный.ДополнительныеСвойства.Вставить("СуммыНалоговогоУчетаЗаполнены", Истина);
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	УчетОС.ПроверитьСоответствиеОСОрганизации(ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.ПроверкиПоОС, Отказ);

	УчетОС.ПроверитьСоответствиеМестонахожденияОС(ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.ПроверкиПоОС, Отказ);

	УчетОС.ПроверитьЗаполнениеСчетаУчетаОС(ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.ПроверкиПоОС, Отказ);

	УчетОС.ПроверитьВозможностьИзмененияСостоянияОС(ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.СостоянияОС, Отказ);

	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-18 (#4405)
	// Учет доходов и расходов ИП
	ТаблицаОприходованияТоваровИП = УчетДоходовИРасходовПредпринимателя.ПодготовитьТаблицуОприходованияТоваров(
		ПараметрыПроведения.ОприходованиеТоваровИПТаблица, ПараметрыПроведения.ОприходованиеТоваровИПРеквизиты);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-18 (#4405)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	ПараметрыВыбытия = УчетОС.ПодготовитьТаблицыСведенийПоВыбытиюОС(ПараметрыПроведения.ОсновныеСредства,
		ПараметрыПроведения.ВыбытиеОС, Отказ);

	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	ТаблицаСтоимости = УчетОС.ПодготовитьТаблицуОстаточнойСтоимости(
		ПараметрыПроведения.СписаниеОстаточнойСтоимостиТаблица,
		ПараметрыПроведения.СписаниеОстаточнойСтоимости, ПараметрыВыбытия, Отказ);

	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-15 (#4405)
	ТаблицыДоходовИРасходов = Документы.СписаниеОС.ПодготовитьДоходыИРасходыСУчетомТоваров(
		ТаблицаСтоимости, ПараметрыПроведения.ОприходованиеТоваровТаблицаТовары);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-15 (#4405)
		
	ТаблицаОСДляСостоянияОС = УчетОС.ПодготовитьТаблицуОСДляСнятияСУчетаПриСписании(ПараметрыПроведения.СостоянияОС,
		ПараметрыВыбытия, Отказ);
		
	// Учет доходов и расходов ИП
	ТаблицыСписанияОСИП	= УчетДоходовИРасходовПредпринимателя.ПодготовитьТаблицыСписанияОСиНМА(
		ПараметрыПроведения.СписаниеОСиНМАИПТаблица,
		ПараметрыПроведения.СписаниеОСиНМАИПРеквизиты, Движения, Отказ);
		
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
		
	// Алгоритмы формирования проводок этого документа рассчитывают суммы проводок налогового учета
	Движения.Хозрасчетный.ДополнительныеСвойства.Вставить("СуммыНалоговогоУчетаЗаполнены", Истина);

	УчетОС.СформироватьДвиженияВыбытиеОС(ПараметрыПроведения.ВыбытиеОС, ПараметрыВыбытия, Движения, Отказ);

	УчетОС.СформироватьДвиженияИзменениеСостоянияОС(ТаблицаОСДляСостоянияОС,
		ПараметрыПроведения.СостоянияОС, Движения, Отказ);

	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-18 (#4405)
	// перенесено ниже
	//УчетОС.СформироватьДвиженияСписаниеОстаточнойСтоимостиОС(ТаблицаСтоимости,
	//	ПараметрыПроведения.СписаниеОстаточнойСтоимости, Движения, Отказ);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-18 (#4405)
		
	// Учет доходов и расходов ИП
	УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияСписаниеОСиНМА(
		ТаблицыСписанияОСИП,
		ПараметрыПроведения.СписаниеОСиНМАИПРеквизиты, Движения, Отказ);
		
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-15 (#4405)
	// Формирование движений оприходования товаров
	
	УчетТоваров.СформироватьДвиженияОприходованиеТоваров(ТаблицыДоходовИРасходов.ОприходованиеТоваров,
		ПараметрыПроведения.ОприходованиеТоваровРеквизиты, Движения, Отказ);
	
	УчетОС.СформироватьДвиженияСписаниеОстаточнойСтоимостиОС(ТаблицыДоходовИРасходов.РасходыОтЛиквидацииОС,
		ПараметрыПроведения.СписаниеОстаточнойСтоимости, Движения, Отказ);
	
	Документы.СписаниеОС.СформироватьДвиженияОтраженияДоходовОтОприходованияТоваров(
		ТаблицыДоходовИРасходов.ДоходыОтОприходованияТоваров,
		ПараметрыПроведения.ОприходованиеТоваровРеквизиты, Движения, Отказ);
	
	РегистрыСведений.РасчетСтоимостиОставшихсяМатериаловПриСписанииОС.СформироватьДвиженияРасчетаСтоимостиОставшихсяЦенностей(
		ТаблицыДоходовИРасходов.РасчетСтоимостиТоваров,
		ПараметрыПроведения.ОприходованиеТоваровРеквизиты, Движения, Отказ);
	
	УчетНДСБП.СформироватьДвиженияОприходованиеТоваров(
		ПараметрыПроведения.ТоварыНДС, ПараметрыПроведения.НомераГТД, ПараметрыПроведения.РеквизитыНДС, Движения, Отказ);
	
	// поступление расходов УСН
	УчетУСН.ПоступлениеРасходовУСН(ПараметрыПроведения.УСНТаблицаРасходов, ПараметрыПроведения.РеквизитыПоступлениеРасходовУСН, 0, Движения, Отказ);
	// отражение доходов УСН в КУДиР
	УчетУСН.СформироватьДвиженияКнигаУчетаДоходовИРасходов(ПараметрыПроведения.РеквизитыУСН, Движения, Отказ);
	
	// Учет доходов и расходов ИП
	УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияОприходованиеТоваров(
		ТаблицаОприходованияТоваровИП, ПараметрыПроведения.ОприходованиеТоваровИПРеквизиты, Движения, Отказ);
		
	// Учет в прослеживаемости
	ПрослеживаемыеОперации = ПодготовитьТаблицуПрослеживаемыеОперации(
		ТаблицыДоходовИРасходов.РасходыОтЛиквидацииОС,
		ПараметрыПроведения.ПрослеживаемыеОС,
		ПараметрыПроведения.ПрослеживаемыеОперации);
		
	ПрослеживаемостьБП.СформироватьДвиженияСписанияОС(
		ПараметрыПроведения.ПрослеживаемыеОС,
		ПрослеживаемыеОперации,
		ПараметрыПроведения.ПрослеживаемостьРеквизиты,
		Движения);
		
	ПрослеживаемостьБП.СформироватьДвиженияПоступлениеТоваров(
		ПараметрыПроведения.Прослеживаемыетовары,
		Неопределено,
		Неопределено,
		ПараметрыПроведения.ПрослеживаемостьРеквизиты,
		Движения);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-15 (#4405)
	
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	УправлениеВнеоборотнымиАктивами.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", Новый Структура("ОсновноеСредство"), Отказ);

	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-15 (#4405)
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ОсталисьМатериальныеЦенностиОтВыбытия Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаДоходов");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	РеквизитыЗаСсылками = Документы.СписаниеОС.РеквизитыЗаСсылками();
	
	СчетаУчетаВДокументах.ПроверитьЗаполнение(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, РеквизитыЗаСсылками);
	
	ПроверкаЗаполненияДокументов.ПроверитьРеквизитыЗаСсылками(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, РеквизитыЗаСсылками);
	
	ПрослеживаемыйТовар = ОС.НайтиСтроки(Новый Структура("ПрослеживаемыйТовар", Истина));
	ЕстьПрослеживаемыйТовар = ПрослеживаемыйТовар.Количество() <> 0;
	Если ЕстьПрослеживаемыйТовар И ОсталисьМатериальныеЦенностиОтВыбытия Тогда 
		НуженКодОперации = ТребуетсяЗаполнениеКодаОперации();
	Иначе
		НуженКодОперации = ЕстьПрослеживаемыйТовар;
	КонецЕсли;
	
	Если НуженКодОперации И Не ЗначениеЗаполнено(КодОперацииПрослеживаемости) Тогда
		ТекстОшибки = НСтр("ru='Не выбрана причина списания в прослеживаемости'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "НадписьКодОперации", , Отказ);
	КонецЕсли;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-15 (#4405) 
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-15 (#4405)
	ВедетсяУчетПрослеживаемыхТоваров = ПолучитьФункциональнуюОпцию("ВестиУчетПрослеживаемыхТоваров")
		И ПрослеживаемостьБРУ.ВедетсяУчетПрослеживаемыхТоваров(Дата);
		
	РаботаСНоменклатурой.ОбновитьПризнакПрослеживаемости(ОС, ВедетсяУчетПрослеживаемыхТоваров, Истина);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-15 (#4405)
КонецПроцедуры

//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-15 (#4405)
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьЛишниеЦенностиОтВыбытия();
	
	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
	ПрослеживаемыеМатериалы = ЦенностиОтВыбытия.НайтиСтроки(Новый Структура("ПрослеживаемыйТовар", Истина));
	ЕстьПрослеживаемыеМатериалы = ПрослеживаемыеМатериалы.Количество() <> 0;
	
	Если ЕстьПрослеживаемыеМатериалы Тогда
		Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
			ПрослеживаемостьБП.СверитьОстаткиРНПТ(ЭтотОбъект, Отказ, "ОС");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-15 (#4405)

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДокументуОснованию(Основание)

	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-15 (#4405)
	ВедетсяУчетПрослеживаемыхТоваров = ПолучитьФункциональнуюОпцию("ВестиУчетПрослеживаемыхТоваров")
			И ПрослеживаемостьБРУ.ВедетсяУчетПрослеживаемыхТоваров(НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя()));
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-15 (#4405)
	
	// Заполним реквизиты из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);

	Если ТипЗнч(Основание) = Тип("СправочникСсылка.ОсновныеСредства") Тогда

		Если Основание.ЭтоГруппа Тогда

			ТекстСообщения = НСтр("ru = 'Ввод списания ОС на основании группы ОС невозможен!
				|Выберите ОС. Для раскрытия группы используйте клавиши Ctrl и стрелку вниз'");
			ВызватьИсключение(ТекстСообщения);

		КонецЕсли;

		СтрокаТабличнойЧасти = ОС.Добавить();
		СтрокаТабличнойЧасти.ОсновноеСредство = Основание;
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-15 (#4405)
		Если ВедетсяУчетПрослеживаемыхТоваров Тогда
			ПрослеживаемыйТовар = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "ПрослеживаемыйТовар");
			СтрокаТабличнойЧасти.ПрослеживаемыйТовар = ПрослеживаемыйТовар;
		Иначе
			СтрокаТабличнойЧасти.ПрослеживаемыйТовар = Ложь;
		КонецЕсли;
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-15 (#4405) 
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЕСТЬNULL(ПервоначальныеСведенияОС.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Организация
		|ИЗ
		|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(&Дата, ОсновноеСредство = &ОсновноеСредство) КАК ПервоначальныеСведенияОС
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение
		|ИЗ
		|	РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(&Дата, ОсновноеСредство = &ОсновноеСредство) КАК МестонахождениеОСБухгалтерскийУчетСрезПоследних";
		Запрос.УстановитьПараметр("Дата", НачалоДня(ТекущаяДатаСеанса()));
		Запрос.УстановитьПараметр("ОсновноеСредство", Основание);
		РезультатЗапроса = Запрос.ВыполнитьПакет();
		Если НЕ РезультатЗапроса[0].Пустой() Тогда
			Выборка = РезультатЗапроса[0].Выбрать();
			Выборка.Следующий();
			Организация = Выборка.Организация;
		КонецЕсли;
		Если НЕ РезультатЗапроса[1].Пустой() Тогда
			Выборка = РезультатЗапроса[1].Выбрать();
			Выборка.Следующий();
			ПодразделениеОрганизации = Выборка.Местонахождение;
		КонецЕсли;

	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ИнвентаризацияОС") Тогда

		Организация = Основание.Организация;

		Для каждого ТекСтрокаОС Из Основание.ОС Цикл
			Если ТекСтрокаОС.НаличиеПоДаннымУчета И НЕ ТекСтрокаОС.НаличиеФактическое Тогда
				НоваяСтрока = ОС.Добавить();
				НоваяСтрока.ОсновноеСредство = ТекСтрокаОС.ОсновноеСредство;
				//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-15 (#4405)
				Если ВедетсяУчетПрослеживаемыхТоваров Тогда
					// Из типовой ошибка
					// ДанныеПоОС = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(НоваяСтрока.ОсновноеСредство, "ПрослеживаемыйТовар");
					// НоваяСтрока.ПрослеживаемыйТовар = ДанныеПоОС.ПрослеживаемыйТовар;
					НоваяСтрока.ПрослеживаемыйТовар = НоваяСтрока.ОсновноеСредство.ПрослеживаемыйТовар;
				Иначе
					НоваяСтрока.ПрослеживаемыйТовар = Ложь;
				КонецЕсли;
				//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-15 (#4405)
			КонецЕсли;
		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-15 (#4405)
Процедура ОчиститьЛишниеЦенностиОтВыбытия()
	
	Если Не ОсталисьМатериальныеЦенностиОтВыбытия Тогда
		ЦенностиОтВыбытия.Очистить();
		Склад = Справочники.Склады.ПустаяСсылка();
		Возврат;
	КонецЕсли;
	
	НомерСтроки = ЦенностиОтВыбытия.Количество();
	Пока НомерСтроки > 0 Цикл
		СтрокаЦенностей = ЦенностиОтВыбытия[НомерСтроки - 1];
		Если ОС.Найти(СтрокаЦенностей.КлючСтроки, "КлючСтроки") = Неопределено Тогда
			ЦенностиОтВыбытия.Удалить(НомерСтроки - 1);
		КонецЕсли;
		НомерСтроки = НомерСтроки - 1;
	КонецЦикла;
	
КонецПроцедуры

Функция ТребуетсяЗаполнениеКодаОперации()
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаОС.ПрослеживаемыйТовар КАК ПрослеживаемыйТовар,
		|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
		|	ТаблицаОС.КлючСтроки КАК КлючСтроки
		|ПОМЕСТИТЬ ТаблицаОС
		|ИЗ
		|	&ТаблицаОС КАК ТаблицаОС
		|ГДЕ
		|	ТаблицаОС.ПрослеживаемыйТовар = ИСТИНА
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОставшиесяМатериалы.КлючСтроки КАК КлючСтроки,
		|	ОставшиесяМатериалы.Номенклатура КАК Номенклатура,
		|	ОставшиесяМатериалы.СтранаПроисхождения КАК СтранаПроисхождения,
		|	ОставшиесяМатериалы.РНПТ КАК РНПТ,
		|	ОставшиесяМатериалы.Количество КАК Количество,
		|	ОставшиесяМатериалы.КоличествоПрослеживаемости КАК КоличествоПрослеживаемости
		|ПОМЕСТИТЬ ТаблицаОставшиесяМатериалы
		|ИЗ
		|	&ОставшиесяМатериалы КАК ОставшиесяМатериалы
		|ГДЕ
		|	ОставшиесяМатериалы.ПрослеживаемыйТовар = ИСТИНА
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПрослеживаемыеОСОстатки.ОсновноеСредство КАК ОС,
		|	ПрослеживаемыеОСОстатки.Организация КАК Организация,
		|	ПрослеживаемыеОСОстатки.РНПТ КАК РНПТ,
		|	ПрослеживаемыеОСОстатки.СтранаПроисхождения КАК СтранаПроисхождения,
		|	СУММА(ПрослеживаемыеОСОстатки.КоличествоОстаток) КАК Количество,
		|	СУММА(ПрослеживаемыеОСОстатки.КоличествоПрослеживаемостиОстаток) КАК КоличествоПрослеживаемости,
		|	ПрослеживаемыеОСОстатки.Комплектующие КАК Комплектующие
		|ПОМЕСТИТЬ ВТ_Прослеживаемость
		|ИЗ
		|	РегистрНакопления.ПрослеживаемыеОсновныеСредства.Остатки(
		|			&МоментСписания,
		|			Организация = &Организация
		|				И ОсновноеСредство В (&МассивОС)) КАК ПрослеживаемыеОСОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	ПрослеживаемыеОСОстатки.РНПТ,
		|	ПрослеживаемыеОСОстатки.СтранаПроисхождения,
		|	ПрослеживаемыеОСОстатки.Организация,
		|	ПрослеживаемыеОСОстатки.Комплектующие,
		|	ПрослеживаемыеОСОстатки.ОсновноеСредство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаОС.ОсновноеСредство КАК ОС,
		|	ТаблицаОставшиесяМатериалы.Номенклатура КАК Номенклатура,
		|	СУММА(ТаблицаОставшиесяМатериалы.Количество) КАК Количество,
		|	СУММА(ТаблицаОставшиесяМатериалы.КоличествоПрослеживаемости) КАК КоличествоПрослеживаемости,
		|	ТаблицаОставшиесяМатериалы.СтранаПроисхождения КАК СтранаПроисхождения,
		|	ТаблицаОставшиесяМатериалы.РНПТ КАК РНПТ
		|ПОМЕСТИТЬ ОстаткиМатериалов
		|ИЗ
		|	ТаблицаОС КАК ТаблицаОС
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОставшиесяМатериалы КАК ТаблицаОставшиесяМатериалы
		|		ПО ТаблицаОС.КлючСтроки = ТаблицаОставшиесяМатериалы.КлючСтроки
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаОставшиесяМатериалы.Номенклатура,
		|	ТаблицаОС.ОсновноеСредство,
		|	ТаблицаОставшиесяМатериалы.СтранаПроисхождения,
		|	ТаблицаОставшиесяМатериалы.РНПТ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Прослеживаемость.ОС КАК ОС,
		|	ВТ_Прослеживаемость.Организация КАК Организация,
		|	ВТ_Прослеживаемость.РНПТ КАК РНПТ,
		|	ВТ_Прослеживаемость.СтранаПроисхождения КАК СтранаПроисхождения,
		|	СУММА(ВТ_Прослеживаемость.Количество - ЕСТЬNULL(ОстаткиМатериалов.Количество, 0)) КАК Количество,
		|	СУММА(ВТ_Прослеживаемость.КоличествоПрослеживаемости - ЕСТЬNULL(ОстаткиМатериалов.КоличествоПрослеживаемости, 0)) КАК КоличествоПрослеживаемости,
		|	ВТ_Прослеживаемость.Комплектующие КАК Комплектующие
		|ПОМЕСТИТЬ РНПТКСписанию
		|ИЗ
		|	ВТ_Прослеживаемость КАК ВТ_Прослеживаемость
		|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиМатериалов КАК ОстаткиМатериалов
		|		ПО ВТ_Прослеживаемость.ОС = ОстаткиМатериалов.ОС
		|			И ВТ_Прослеживаемость.Комплектующие = ОстаткиМатериалов.Номенклатура
		|			И ВТ_Прослеживаемость.СтранаПроисхождения = ОстаткиМатериалов.СтранаПроисхождения
		|			И ВТ_Прослеживаемость.РНПТ = ОстаткиМатериалов.РНПТ
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_Прослеживаемость.ОС,
		|	ВТ_Прослеживаемость.РНПТ,
		|	ВТ_Прослеживаемость.СтранаПроисхождения,
		|	ВТ_Прослеживаемость.Комплектующие,
		|	ВТ_Прослеживаемость.Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РНПТКСписанию.ОС КАК ОС
		|ИЗ
		|	РНПТКСписанию КАК РНПТКСписанию
		|ГДЕ
		|	РНПТКСписанию.Количество > 0";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МоментСписания", Новый МоментВремени(Дата, Ссылка));
	Запрос.УстановитьПараметр("ТаблицаОС", ОС.Выгрузить());
	Запрос.УстановитьПараметр("ОставшиесяМатериалы", ЦенностиОтВыбытия.Выгрузить());
	Запрос.УстановитьПараметр("МассивОС", ОС.ВыгрузитьКолонку("ОсновноеСредство"));
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда 
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

Функция ПодготовитьТаблицуПрослеживаемыеОперации(ТаблицаОстаточнойСтоимости, ПрослеживаемыеОС, ПрослеживаемыеОперации)
	
	Если ПрослеживаемыеОперации = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	Для Каждого Строка Из ПрослеживаемыеОперации Цикл
		ДанныеПоОС = ПрослеживаемыеОС.НайтиСтроки(Новый Структура("ОсновноеСредство", Строка.Номенклатура));
		КоличествоСтрокПоОС = ДанныеПоОС.Количество();
		Если КоличествоСтрокПоОС <> 1 Тогда
			Продолжить;
		Иначе
			СтоимостьПоОС = ТаблицаОстаточнойСтоимости.Найти(Строка.Номенклатура, "ОсновноеСредство");
			Если СтоимостьПоОС <> Неопределено Тогда
				Строка.СуммаБезНДС = СтоимостьПоОС.СтоимостьБУ;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПрослеживаемыеОперации;
	
КонецФункции
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-15 (#4405) 
#КонецОбласти

#КонецЕсли