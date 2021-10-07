﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 6, 0);
	
КонецФункции


Процедура ПроверитьРегистрациюВСистемеПлатон(Объект, Параметры, Отказ) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ТаблицаТС", Параметры.ТаблицаТС);
	Запрос.УстановитьПараметр("Организация", Параметры.Организация);
	Запрос.УстановитьПараметр("Период", Параметры.Дата);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаТС.НомерСтроки,
	|	ТаблицаТС.ТранспортноеСредство КАК ТранспортноеСредство
	|ПОМЕСТИТЬ ТранспортныеСредства
	|ИЗ
	|	&ТаблицаТС КАК ТаблицаТС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТранспортноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РегистрацияТранспортныхСредствСрезПоследних.ОсновноеСредство КАК ОсновноеСредство,
	|	РегистрацияТранспортныхСредствСрезПоследних.ЗарегистрированоВРеестреСистемыПлатон КАК ЗарегистрированоВРеестреСистемыПлатон
	|ПОМЕСТИТЬ РегистрацииВСистемеПлатон
	|ИЗ
	|	РегистрСведений.РегистрацияТранспортныхСредств.СрезПоследних(
	|			&Период,
	|			Организация = &Организация
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						ТранспортныеСредства.ТранспортноеСредство
	|					ИЗ
	|						ТранспортныеСредства)) КАК РегистрацияТранспортныхСредствСрезПоследних
	|ГДЕ
	|	РегистрацияТранспортныхСредствСрезПоследних.ВключатьВНалоговуюБазу
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство,
	|	ЗарегистрированоВРеестреСистемыПлатон
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТранспортныеСредства.НомерСтроки,
	|	ТранспортныеСредства.ТранспортноеСредство
	|ИЗ
	|	ТранспортныеСредства КАК ТранспортныеСредства
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрацииВСистемеПлатон КАК РегистрацииВСистемеПлатон
	|		ПО ТранспортныеСредства.ТранспортноеСредство = РегистрацииВСистемеПлатон.ОсновноеСредство
	|ГДЕ
	|	НЕ ЕСТЬNULL(РегистрацииВСистемеПлатон.ЗарегистрированоВРеестреСистемыПлатон, ЛОЖЬ)";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонСообщения = НСтр("ru = 'Для транспортного средства <%1> не отражена регистрация в системе ""Платон"".'");
	ШаблонПоля = "ТранспортныеСредства[%1].ТранспортноеСредство";
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Поле = СтрШаблон(ШаблонПоля, Формат(Выборка.НомерСтроки - 1, "ЧН=0; ЧГ="));
		ТекстСообщения = СтрШаблон(ШаблонСообщения, Выборка.ТранспортноеСредство);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект, Поле, "Объект", Отказ);
		
	КонецЦикла;
	
КонецПроцедуры


Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ, ДоговорДляОтложенногоПроведения = Неопределено) Экспорт

	ПараметрыПроведения = Новый Структура;

	ЭтоОтложенноеПроведение = ЗначениеЗаполнено(ДоговорДляОтложенногоПроведения);

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("ВалютаРеглУчета", ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента();
	Результат    = Запрос.ВыполнитьПакет();
	ТаблицаРеквизиты = Результат[1].Выгрузить();
	ПараметрыПроведения.Вставить("Реквизиты", ТаблицаРеквизиты);
	
	Реквизиты = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРеквизиты[0]);
	Если НЕ УчетнаяПолитика.Существует(Реквизиты.Организация, Реквизиты.Период, Истина, ДокументСсылка) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;
	
	Реквизиты.Вставить("ЭтоОтложенноеПроведение", ЭтоОтложенноеПроведение);
	
	Запрос.Текст = ТекстЗапросаВременнаяТаблицаТранспортныеСредства();
	Результат    = Запрос.Выполнить();

	НомераТаблиц = Новый Структура;
	Запрос.Текст = ТекстЗапросаЗачетАвансов(НомераТаблиц, ПараметрыПроведения, Реквизиты)
		+ ТекстЗапросаРасходы(НомераТаблиц, ПараметрыПроведения, Реквизиты)
		+ ТекстЗапросаРасходыНаПлатон(НомераТаблиц, ПараметрыПроведения, Реквизиты)
		+ ТекстЗапросаРегистрацияОтложенныхРасчетовСКонтрагентами(НомераТаблиц, ПараметрыПроведения, Реквизиты);

	Результат = Запрос.ВыполнитьПакет();

	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;

	Возврат ПараметрыПроведения;

КонецФункции

Функция ОсобенностиУчетаРасчетов() Экспорт
	
	ОсобенностиДокумента = УчетВзаиморасчетовФормы.НовыйОсобенностиУчетаРасчетовДокумента();
	
	ОсобенностиДокумента.ТребуетсяУчетСроковОплаты = Ложь;
	
	Возврат ОсобенностиДокумента;
	
КонецФункции


Процедура СформироватьДвиженияРасходыНаПлатон(ТаблицаРасходыНаПлатон, ТаблицаРеквизиты, Движения, Отказ) Экспорт
	
	Если Не ЗначениеЗаполнено(ТаблицаРасходыНаПлатон)
	 Или Не ЗначениеЗаполнено(ТаблицаРеквизиты) Тогда
	    Возврат;
	КонецЕсли;
	
	Параметры = ПодготовитьПараметрыРасходыНаПлатон(ТаблицаРасходыНаПлатон, ТаблицаРеквизиты);
	Реквизиты = Параметры.Реквизиты[0];
	
	Для каждого СтрокаТаблицы Из Параметры.ТаблицаРасходыНаПлатон Цикл

		Если СтрокаТаблицы.Сумма = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Движение = Движения.РасходыНаПлатон.Добавить();
		
		ЗаполнитьЗначенияСвойств(Движение, Реквизиты);
		ЗаполнитьЗначенияСвойств(Движение, СтрокаТаблицы);

	КонецЦикла;
	
	Движения.РасходыНаПлатон.Записывать = Истина;
	
КонецПроцедуры

Функция ПодготовитьПараметрыРасходыНаПлатон(ТаблицаРасходыНаПлатон, ТаблицаРеквизиты)
	
	Параметры = Новый Структура;
	
	// Подготовка таблицы шапки документа
	СписокОбязательныхКолонок = ""
	+ "Период,"                  // <Дата> - дата документа
	+ "Регистратор,"             // <ДокументСсылка> - документ, записывающий движения в регистры
	+ "Организация,"             // <СправочникСсылка.Организации> - организация документа
	;
	
	Параметры.Вставить("Реквизиты", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(ТаблицаРеквизиты, СписокОбязательныхКолонок));
	
	// Подготовка таблицы:
	СписокОбязательныхКолонок = ""
	+ "НомерСтроки,"                   // <Число, 5, 0>
	+ "ОсновноеСредство,"              // <СправочникСсылка.ОсновныеСредства>
	+ "СчетУчета,"                     // <ПланСчетовСсылка.Хозрасчетный>
	+ "Контрагент,"                    // <СправочникСсылка.Контрагенты>
	+ "ДоговорКонтрагента,"            // <СправочникСсылка.ДоговорыКонтрагентов>
	+ "ДокументРасчетовСКонтрагентом," // <ДокументСсылка>
	+ "Подразделение,"                 // <СправочникСсылка.ПодразделенияОрганизаций>
	+ "Сумма"                          // <Число, 15, 2>
	;
	Параметры.Вставить("ТаблицаРасходыНаПлатон", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(ТаблицаРасходыНаПлатон, СписокОбязательныхКолонок));

	Возврат Параметры;

КонецФункции


Процедура ЗарегистрироватьОтложенныеРасчетыВПоследовательности(Объект, ПараметрыПроведения, ТаблицаРасходы, Отказ) Экспорт

	ВключенВПоследовательность = РаботаСПоследовательностями.ЗарегистрироватьОтложенныеРасчетыВПоследовательности(
		Объект,
		Отказ,
		ПараметрыПроведения.РасчетыСКонтрагентамиОтложенноеПроведение,
		,
		Перечисления.ВидыРегламентныхОпераций.ПустаяСсылка());

	Если ВключенВПоследовательность Тогда
		// Документ включен в последовательность, больше с ним не требуется ничего делать.
		Возврат;
	КонецЕсли;

	Параметры = ПодготовитьПараметрыЗарегистрироватьОтложенныеРасчетыВПоследовательности(ТаблицаРасходы);
	ТаблицаУслуги = Параметры.ТаблицаУслуги;
	
	// Если документ регистрирует поступление услуг и при этом не был включен в последовательность,
	// то сбросим актуальность для тех рег.операций, которые зависят от соответствующих счетов.
	РаботаСПоследовательностями.ЗарегистрироватьУстареваниеРегламентныхОперацийПриПоступленииЗатрат(
		Объект, ТаблицаУслуги.ВыгрузитьКолонку("СчетЗатрат"));
	
КонецПроцедуры

Функция ПодготовитьПараметрыЗарегистрироватьОтложенныеРасчетыВПоследовательности(ТаблицаУслуги)

	Параметры = Новый Структура;
	
	// Услуги
	СписокОбязательныхКолонок = ""
	+ "СчетЗатрат" // <ПланСчетовСсылка.Хозрасчетный> - Счет учета поступивших услуг.
	;

	Параметры.Вставить("ТаблицаУслуги",
		ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(ТаблицаУслуги, СписокОбязательныхКолонок));
		
	Возврат Параметры;

КонецФункции


Процедура ОбработкаОтложенногоПроведения(Параметры, Отказ) Экспорт
	
	ПараметрыПроведения = ПодготовитьПараметрыПроведения(
		Параметры.Регистратор,
		Отказ,
		Параметры.ДоговорКонтрагента);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;	

	ТаблицаВзаиморасчетов = УчетВзаиморасчетовОтложенноеПроведение.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(
		Параметры,
		ПараметрыПроведения.ЗачетАвансовТаблицаДокумента,
		ПараметрыПроведения.ТаблицаЗачетАвансов,
		ПараметрыПроведения.ЗачетАвансовРеквизиты,
		Отказ);

	УчетВзаиморасчетовОтложенноеПроведение.СформироватьДвиженияЗачетАвансов(
		Параметры,
		ТаблицаВзаиморасчетов,
		ПараметрыПроведения.ЗачетАвансовРеквизиты,
		Отказ);

КонецПроцедуры


Функция ПодготовитьТаблицуРасходов(ТаблицаРасходы, ТаблицаРеквизиты, Объект, Отказ) Экспорт
	
	Параметры = ПодготовитьПараметрыТаблицаРасходов(ТаблицаРасходы, ТаблицаРеквизиты);
	Параметры.ТаблицаРасходы.Колонки.Добавить("Содержание", ОбщегоНазначения.ОписаниеТипаСтрока(150));
	
	Если Параметры.Реквизиты.Количество() = 0
		ИЛИ Параметры.ТаблицаРасходы.Количество() = 0 Тогда
		Возврат Параметры.ТаблицаРасходы;
	КонецЕсли;
	
	Реквизиты = Параметры.Реквизиты[0];
	
	СпособыОтраженияРасходов = РасчетИмущественныхНалогов.СпособыОтраженияРасходовПоНалогам(
		Реквизиты.Организация,
		Параметры.ТаблицаРасходы.ВыгрузитьКолонку("ТранспортноеСредство"),
		Перечисления.ВидыИмущественныхНалогов.ТранспортныйНалог,
		Реквизиты.Период);
	
	Для каждого СтрокаТаблицы Из Параметры.ТаблицаРасходы Цикл
		
		СпособОтраженияРасходов = СпособыОтраженияРасходов[СтрокаТаблицы.ТранспортноеСредство];
		
		ШаблонСообщения = НСтр("ru = 'Не установлен способ отражения расходов по транспортному налогу для объекта %1'");
		ШаблонПоля = "ТранспортныеСредства[%1].ТранспортноеСредство";
		
		Если СпособОтраженияРасходов = Неопределено Тогда
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонСообщения, Строка(СтрокаТаблицы.ТранспортноеСредство));
			Поле = СтрШаблон(ШаблонПоля, Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ="));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект, Поле, "Объект", Отказ);
			
			Продолжить;
			
		КонецЕсли;
		
		СтрокаТаблицы.СчетЗатрат          = СпособОтраженияРасходов.СчетДт;
		СтрокаТаблицы.ПодразделениеЗатрат = СпособОтраженияРасходов.Подразделение;
		СтрокаТаблицы.Субконто1           = СпособОтраженияРасходов.Субконто1;
		СтрокаТаблицы.Субконто2           = СпособОтраженияРасходов.Субконто2;
		СтрокаТаблицы.Субконто3           = СпособОтраженияРасходов.Субконто3;
		
		СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТаблицы.СчетЗатрат);
		
		Для Ном = 1 По СвойстваСчета.КоличествоСубконто Цикл
			Если СвойстваСчета["ВидСубконто" + Ном] = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат Тогда
				СтрокаТаблицы["Субконто" + Ном] = Справочники.СтатьиЗатрат.ОсновнаяСтатьяЗатрат();
			КонецЕсли;
		КонецЦикла;
		
		Если Реквизиты.Период < '20160101' ИЛИ Реквизиты.Период >= '20190101' Тогда
			СтрокаТаблицы.СчетЗатратНУ = СтрокаТаблицы.СчетЗатрат;
			СтрокаТаблицы.СубконтоНУ1  = СтрокаТаблицы.Субконто1;
			СтрокаТаблицы.СубконтоНУ2  = СтрокаТаблицы.Субконто2;
			СтрокаТаблицы.СубконтоНУ3  = СтрокаТаблицы.Субконто3;
		КонецЕсли;
		
		СтрокаТаблицы.Содержание = НСтр("ru = 'Отражен в расходах платеж в систему ""Платон""'");
		
	КонецЦикла;
	
	Возврат Параметры.ТаблицаРасходы;
	
КонецФункции

Функция ПодготовитьПараметрыТаблицаРасходов(ТаблицаРасходы, ТаблицаРеквизиты)

	Параметры = Новый Структура;
	
	// Подготовка таблицы шапки документа
	СписокОбязательныхКолонок = ""
	+ "Период,"                 // <Дата> - дата документа
	+ "Организация"             // <СправочникСсылка.Организации> - организация документа
	;
	
	Параметры.Вставить("Реквизиты", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
		ТаблицаРеквизиты, СписокОбязательныхКолонок));
	
	// Подготовка таблицы:
	СписокОбязательныхКолонок = ""
	+ "НомерСтроки,"            // <Число,5 , 0>
	+ "ТранспортноеСредство,"   // <СправочникСсылка.ОсновныеСредства>
	+ "СуммаВзаиморасчетов,"    // <Число, 15, 2> - сумма в валюте взаиморасчетов с учетом курса расчетов по авансам
	+ "СуммаБУ,"                // <Число, 15, 2> - сумма взаиморасчетов для целей БУ
	+ "СуммаНУ,"                // <Число, 15, 2> - сумма взаиморасчетов для целей НУ
	+ "СчетЗатрат,"             // <ПланСчетовСсылка.Хозрасчетный> - счет, на который относятся затраты по полученным услугам
	+ "Субконто1,"              // <ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные>
	+ "Субконто2,"              // <ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные>
	+ "Субконто3,"              // <ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные>
	+ "КорСчет,"                // <ПланСчетовСсылка.Хозрасчетный> - счет, с которого поступает услуга
	+ "ВидКорСубконто1,"        // <Число/Строка/ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные> - вид субконто
		// счета, с которого поступает услуга
	+ "ВидКорСубконто2,"        // <Число/Строка/ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные> - вид субконто
		// счета, с которого поступает услуга
	+ "ВидКорСубконто3,"        // <Число/Строка/ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные> - вид субконто
		// счета, с которого поступает услага
	+ "КорСубконто1,"           // <Характеристика.ВидыСубконтоХозрасчетные> - значение субконто счета, с которого
		// поступает услуга
	+ "КорСубконто2,"           // <Характеристика.ВидыСубконтоХозрасчетные> - значение субконто счета, с которого
		// поступает услуга
	+ "КорСубконто3,"           // <Характеристика.ВидыСубконтоХозрасчетные> - значение субконто счета, с которого
		// поступает услуга
	+ "СчетЗатратНУ,"           // <ПланСчетовСсылка.Хозрасчетный> - счет, на который относятся затраты для целей НУ
	+ "СубконтоНУ1,"            // <Характеристика.ВидыСубконтоХозрасчетные>
	+ "СубконтоНУ2,"            // <Характеристика.ВидыСубконтоХозрасчетные>
	+ "СубконтоНУ3,"            // <Характеристика.ВидыСубконтоХозрасчетные>
	+ "ПодразделениеЗатрат"     // <СправочникСсылка.ПодразделенияОрганизаций> - Подразделение, на которое будут отнесены затраты по услугам
	;
	
	Параметры.Вставить("ТаблицаРасходы", ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(
		ТаблицаРасходы, СписокОбязательныхКолонок));

	Возврат Параметры;

КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Реестр документов ""Отчет оператора системы ""Платон""""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "Контрагент");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаРеквизитыДокумента()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка,
	|	Реквизиты.Дата,
	|	НЕОПРЕДЕЛЕНО КАК ВидОперации,
	|	Реквизиты.Организация,
	|	Реквизиты.ПодразделениеОрганизации,
	|	Реквизиты.Контрагент,
	|	Реквизиты.ДоговорКонтрагента,
	|	ЕСТЬNULL(Реквизиты.ДоговорКонтрагента.ВидДоговора, НЕОПРЕДЕЛЕНО) КАК ВидДоговора,
	|	Реквизиты.СпособЗачетаАвансов,
	|	Реквизиты.СчетУчетаРасчетовСКонтрагентом,
	|	Реквизиты.СчетУчетаРасчетовПоАвансам
	|ПОМЕСТИТЬ Реквизиты
	|ИЗ
	|	Документ.ОтчетОператораСистемыПлатон КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.ВидОперации,
	|	Реквизиты.Организация,
	|	Реквизиты.ПодразделениеОрганизации КАК Подразделение,
	|	Реквизиты.Контрагент,
	|	Реквизиты.ДоговорКонтрагента,
	|	Реквизиты.СпособЗачетаАвансов,
	|	Реквизиты.СчетУчетаРасчетовСКонтрагентом,
	|	Реквизиты.СчетУчетаРасчетовПоАвансам,
	|	&ВалютаРеглУчета КАК ВалютаВзаиморасчетов
	|ИЗ
	|	Реквизиты КАК Реквизиты";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВременнаяТаблицаТранспортныеСредства()

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаТС.Ссылка,
	|	ТаблицаТС.НомерСтроки,
	|	ТаблицаТС.ТранспортноеСредство,
	|	ТаблицаТС.Сумма
	|ПОМЕСТИТЬ ТаблицаТС
	|ИЗ
	|	Документ.ОтчетОператораСистемыПлатон.ТранспортныеСредства КАК ТаблицаТС
	|ГДЕ
	|	ТаблицаТС.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаЗачетАвансов(НомераТаблиц, ПараметрыПроведения, Реквизиты)
	
	НомераТаблиц.Вставить("ВременнаяТаблицаСуммВзаиморасчетов", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ЗачетАвансовРеквизиты",              НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ЗачетАвансовТаблицаДокумента",       НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	СУММА(ТаблицаСуммВзаиморасчетов.СуммаВзаиморасчетов) КАК СуммаВзаиморасчетов,
	|	СУММА(ТаблицаСуммВзаиморасчетов.СуммаРуб) КАК СуммаРуб
	|ПОМЕСТИТЬ ТаблицаСуммВзаиморасчетов
	|ИЗ
	|	(ВЫБРАТЬ
	|		0 КАК СуммаВзаиморасчетов,
	|		0 КАК СуммаРуб
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаТС.Сумма,
	|		ТаблицаТС.Сумма
	|	ИЗ
	|		ТаблицаТС КАК ТаблицаТС) КАК ТаблицаСуммВзаиморасчетов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.ВидОперации КАК ВидОперации,
	|	Реквизиты.Организация КАК Организация,
	|	&ВалютаРеглУчета КАК ВалютаДокумента,
	|	Реквизиты.СпособЗачетаАвансов КАК СпособЗачетаАвансов,
	|	ЛОЖЬ КАК УчитыватьЗадолженностьУСН,
	|	ЛОЖЬ КАК УчитыватьЗадолженностьУСНПатент,
	|	ЛОЖЬ КАК ДеятельностьНаПатенте,
	|	ЛОЖЬ КАК ДеятельностьНаТорговомСборе,
	|	""Поступление"" КАК НаправлениеДвижения,
	|	ЛОЖЬ КАК ЭтоВозврат,
	|	ЛОЖЬ КАК НДСВключенВСтоимость,
	|	ЛОЖЬ КАК УчетАгентскогоНДС
	|ИЗ
	|	Реквизиты КАК Реквизиты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК ДокументРасчетов,
	|	Реквизиты.СчетУчетаРасчетовСКонтрагентом КАК СчетРасчетов,
	|	Реквизиты.СчетУчетаРасчетовПоАвансам КАК СчетАвансов,
	|	Реквизиты.Контрагент,
	|	Реквизиты.ДоговорКонтрагента,
	|	Реквизиты.ВидДоговора КАК ВидДоговора,
	|	&ВалютаРеглУчета КАК ВалютаВзаиморасчетов,
	|	ЛОЖЬ КАК РасчетыВУсловныхЕдиницах,
	|	ЛОЖЬ КАК УчетАгентскогоНДС,
	|	ЛОЖЬ КАК РасчетыВВалюте,
	|	Реквизиты.ПодразделениеОрганизации КАК Подразделение,
	|	ТаблицаСуммВзаиморасчетов.СуммаВзаиморасчетов,
	|	ТаблицаСуммВзаиморасчетов.СуммаРуб,
	|	0 КАК СуммаВзаиморасчетовКомитента,
	|	0 КАК СуммаВзаиморасчетовЕНВД,
	|	0 КАК СуммаВзаиморасчетовПатент,
	|	0 КАК СуммаВзаиморасчетовТорговыйСбор
	|ИЗ
	|	Реквизиты КАК Реквизиты
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаСуммВзаиморасчетов КАК ТаблицаСуммВзаиморасчетов
	|		ПО (ИСТИНА)"
	+ ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
	Если Реквизиты.СпособЗачетаАвансов <> Перечисления.СпособыЗачетаАвансов.ПоДокументу Тогда
		ПараметрыПроведения.Вставить("ТаблицаЗачетАвансов", Неопределено);
	Иначе
		НомераТаблиц.Вставить("ТаблицаЗачетАвансов", НомераТаблиц.Количество());
		ТекстЗапроса = ТекстЗапроса + 
		"ВЫБРАТЬ
		|	ОтчетОператораСистемыПлатонЗачетАвансов.НомерСтроки КАК НомерСтроки,
		|	Реквизиты.СчетУчетаРасчетовПоАвансам КАК СчетАвансов,
		|	Реквизиты.Контрагент,
		|	Реквизиты.ДоговорКонтрагента,
		|	ОтчетОператораСистемыПлатонЗачетАвансов.ДокументАванса,
		|	ОтчетОператораСистемыПлатонЗачетАвансов.СуммаЗачета
		|ИЗ
		|	Документ.ОтчетОператораСистемыПлатон.ЗачетАвансов КАК ОтчетОператораСистемыПлатонЗачетАвансов
		|		ЛЕВОЕ СОЕДИНЕНИЕ Реквизиты КАК Реквизиты
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ОтчетОператораСистемыПлатонЗачетАвансов.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки"
		+ ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	КонецЕсли;
	
	Возврат ТекстЗапроса;
		
КонецФункции

Функция ТекстЗапросаРасходы(НомераТаблиц, ПараметрыПроведения, Реквизиты)

	Если Реквизиты.ЭтоОтложенноеПроведение Тогда
		ПараметрыПроведения.Вставить("ТаблицаРасходы", Неопределено);
		Возврат "";
	КонецЕсли;
	
	НомераТаблиц.Вставить("ТаблицаРасходы", НомераТаблиц.Количество());
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаРасходы.Ссылка,
	|	""ТранспортныеСредства"" КАК ИмяСписка,
	|	ТаблицаРасходы.НомерСтроки КАК НомерСтроки,
	|	ТаблицаРасходы.ТранспортноеСредство КАК ТранспортноеСредство,
	|	ТаблицаРасходы.Сумма КАК СуммаВзаиморасчетов,
	|	ТаблицаРасходы.Сумма КАК СуммаНДСВзаиморасчетов,
	|	ТаблицаРасходы.Сумма КАК СуммаБУ,
	|	ТаблицаРасходы.Сумма КАК СуммаНУ,
	|	ТаблицаРасходы.Сумма КАК СуммаРуб,
	|	0 КАК СуммаНДСРуб,
	|	НЕОПРЕДЕЛЕНО КАК СчетЗатрат,
	|	НЕОПРЕДЕЛЕНО КАК СчетУчетаНДС,
	|	НЕОПРЕДЕЛЕНО КАК СпособУчетаНДС,
	|	НЕОПРЕДЕЛЕНО КАК СтавкаНДС,
	|	НЕОПРЕДЕЛЕНО КАК Субконто1,
	|	НЕОПРЕДЕЛЕНО КАК Субконто2,
	|	НЕОПРЕДЕЛЕНО КАК Субконто3,
	|	Реквизиты.СчетУчетаРасчетовСКонтрагентом КАК КорСчет,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты) КАК ВидКорСубконто1,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры) КАК ВидКорСубконто2,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами) КАК ВидКорСубконто3,
	|	Реквизиты.Контрагент КАК КорСубконто1,
	|	Реквизиты.ДоговорКонтрагента КАК КорСубконто2,
	|	Реквизиты.Ссылка КАК КорСубконто3,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПрочиеРасходыБудущихПериодов) КАК СчетЗатратНУ,
	|	ЗНАЧЕНИЕ(Справочник.РасходыБудущихПериодов.РасходыНаПлатон) КАК СубконтоНУ1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоНУ2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоНУ3,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеЗатрат
	|ИЗ
	|	ТаблицаТС КАК ТаблицаРасходы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Реквизиты КАК Реквизиты
	|		ПО (ИСТИНА)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки"
	+ ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапросаРасходыНаПлатон(НомераТаблиц, ПараметрыПроведения, Реквизиты)

	Если Реквизиты.ЭтоОтложенноеПроведение 
	 ИЛИ Реквизиты.Период < '20160101' ИЛИ Реквизиты.Период >= '20190101' Тогда
		ПараметрыПроведения.Вставить("ТаблицаРасходыНаПлатон", Неопределено);
		Возврат "";
	КонецЕсли;

	НомераТаблиц.Вставить("ТаблицаРасходыНаПлатон", НомераТаблиц.Количество());

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаТС.Ссылка,
	|	ТаблицаТС.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТС.ТранспортноеСредство КАК ОсновноеСредство,
	|	ТаблицаТС.Сумма КАК Сумма,
	|	Реквизиты.СчетУчетаРасчетовСКонтрагентом КАК СчетУчета,
	|	Реквизиты.Контрагент КАК Контрагент,
	|	Реквизиты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	Реквизиты.Ссылка КАК ДокументРасчетовСКонтрагентом,
	|	Реквизиты.ПодразделениеОрганизации КАК Подразделение
	|ИЗ
	|	ТаблицаТС КАК ТаблицаТС
	|		ЛЕВОЕ СОЕДИНЕНИЕ Реквизиты КАК Реквизиты
	|		ПО (ИСТИНА)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки"
	+ ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапросаРегистрацияОтложенныхРасчетовСКонтрагентами(НомераТаблиц, ПараметрыПроведения, Реквизиты)

	Если Реквизиты.ЭтоОтложенноеПроведение
		ИЛИ НЕ ПроведениеСервер.ИспользуетсяОтложенноеПроведение(Реквизиты.Организация, Реквизиты.Период) Тогда
		ПараметрыПроведения.Вставить("РасчетыСКонтрагентамиОтложенноеПроведение", Неопределено);
		Возврат "";
	КонецЕсли;
	
	НомераТаблиц.Вставить("РасчетыСКонтрагентамиОтложенноеПроведение", НомераТаблиц.Количество());

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Реквизиты.Контрагент КАК Контрагент,
	|	Реквизиты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	&ВалютаРеглУчета КАК ВалютаВзаиморасчетов,
	|	Реквизиты.ВидДоговора КАК ВидДоговора,
	|	Реквизиты.Дата КАК Дата
	|ИЗ
	|	Реквизиты КАК Реквизиты";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

#КонецОбласти

#КонецЕсли