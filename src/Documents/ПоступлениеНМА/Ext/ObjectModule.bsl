﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.ПоступлениеНМА.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ (АНАЛИЗ ОСТАТКОВ И Т.П.)
	
	// Таблица взаиморасчетов
	ТаблицаВзаиморасчеты = УчетВзаиморасчетов.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(ПараметрыПроведения.ЗачетАвансовТаблицаДокумента,
		ПараметрыПроведения.ЗачетАвансовТаблицаАвансов, ПараметрыПроведения.ЗачетАвансовРеквизиты, Отказ);
	
	// Таблицы документа с корректировкой сумм по курсу авансов
	СтруктураТаблицДокумента = УчетДоходовРасходов.ПодготовитьТаблицыПоступленияПоКурсуАвансов(ПараметрыПроведения.СтруктураТаблицДокумента,
		ТаблицаВзаиморасчеты, ПараметрыПроведения.ЗачетАвансовРеквизиты);
	
	Документы.ПоступлениеНМА.ДобавитьКолонкуСодержание(ПараметрыПроведения.ПоступлениеНематериальныхАктивовРеквизиты,
		СтруктураТаблицДокумента.ТаблицаНематериальныеАктивы);
		
	// Структура таблиц для отражения в налоговом учете УСН
	СтруктураТаблицУСН = Новый Структура("ТаблицаРасчетов", ТаблицаВзаиморасчеты);
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	// Зачет аванса
	УчетВзаиморасчетов.СформироватьДвиженияЗачетАвансов(ТаблицаВзаиморасчеты,
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);
		
	// Поступление нематериальных активов
	УчетНМА.СформироватьДвиженияПоступлениеНМА(СтруктураТаблицДокумента.ТаблицаНематериальныеАктивы,
		ПараметрыПроведения.ПоступлениеНематериальныхАктивовРеквизиты, Движения, Отказ);
		
	// Установка состояния НМА
	УчетНМА.СформироватьДвиженияСостоянияНМАОрганизаций(СтруктураТаблицДокумента.ТаблицаНематериальныеАктивы,
		ПараметрыПроведения.ПоступлениеНематериальныхАктивовРеквизиты, Движения, Отказ);
		
	//Движения регистра "Рублевые суммы документов в валюте"
	УчетНДСБП.СформироватьДвиженияРублевыеСуммыДокументовВВалютеПоступлениеСобственныхТоваровУслуг(СтруктураТаблицДокумента.ТаблицаНематериальныеАктивы, 
		ПараметрыПроведения.ПоступлениеНематериальныхАктивовРеквизиты, Движения, Отказ);
	
	// Учет НДС
	УчетНДС.СформироватьДвиженияПоступлениеНематериальныхАктивовОтПоставщика(
		СтруктураТаблицДокумента.ТаблицаНематериальныеАктивы,
		ПараметрыПроведения.РеквизитыНДС, Движения, Отказ);
		
	УчетНДСРаздельный.СформироватьДвиженияПоступлениеНематериальныхАктивовОтПоставщика(
		СтруктураТаблицДокумента.ТаблицаНематериальныеАктивы,
		ПараметрыПроведения.РеквизитыНДС, Движения, Отказ);
		
	// УСН
	НалоговыйУчетУСН.СформироватьДвиженияУСН(ЭтотОбъект, СтруктураТаблицУСН);

	// Переоценка валютных остатков - после формирования проводок всеми другими механизмами
	ТаблицаПереоценка = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.ПереоценкаВалютныхОстатковРеквизиты, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка,
		ПараметрыПроведения.ПереоценкаВалютныхОстатковРеквизиты, Движения, Отказ);

	УчетУСН.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка,
		ПараметрыПроведения.ПереоценкаВалютныхОстатковРеквизиты, Движения, Отказ);

	РаботаСПоследовательностями.ЗарегистрироватьВПоследовательности(ЭтотОбъект, Отказ, Ложь);
		
	// Отложенные расчеты с контрагентами.
	УчетВзаиморасчетовОтложенноеПроведение.ЗарегистрироватьОтложенныеРасчетыСКонтрагентами(
		ЭтотОбъект, Отказ, ПараметрыПроведения.РасчетыСКонтрагентамиОтложенноеПроведение);
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
		
	Движения.Записать();
	
	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("Проведен", ЭтотОбъект, "СчетФактураПолученный");	
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ);
	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2018-07-09 (#3052)
	Если ПараметрыПроведения.Свойство("ТаблицаНематериальныеАктивы") И
		 ПараметрыПроведения.ТаблицаНематериальныеАктивы <> Неопределено И
		 ПараметрыПроведения.ТаблицаНематериальныеАктивы.Количество()>0
	Тогда 
		
		стрТаблицыДляПроведенияПоБК = Новый Структура;
			
		пИменаКолонокТаблиц = "Ссылка,Период,НомерСтроки,ЦФО,СтатьяОборотов,ВидСтатьи,Проект,Аналитика_2,СуммаРуб,СуммаНДСРуб";
		
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2019-01-28 (#3192)
		пИменаКолонокТаблиц = пИменаКолонокТаблиц + ",СчетУчета";
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2019-01-28 (#3192)
		
		пРасчетыВВалюте = ПараметрыПроведения.ПоступлениеНематериальныхАктивовРеквизиты[0].ВалютаВзаиморасчетов<>ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		
		Если пРасчетыВВалюте Тогда 
			пИменаКолонокТаблиц = пИменаКолонокТаблиц + ",СуммаВзаиморасчетов,СуммаНДСВзаиморасчетов";
		КонецЕсли;
		
		стрТаблицыДляПроведенияПоБК.Вставить("ТаблицаНематериальныеАктивы", ПараметрыПроведения.СтруктураТаблицДокумента["ТаблицаНематериальныеАктивы"].Скопировать(,пИменаКолонокТаблиц));
		
		Если НЕ пРасчетыВВалюте Тогда 
			Для Каждого КлючЗнчТаб Из стрТаблицыДляПроведенияПоБК Цикл 
				пТаблица = КлючЗнчТаб.Значение;
				пТаблица.Колонки.Добавить("СуммаВзаиморасчетов"	  , Новый ОписаниеТипов("Число"));
				пТаблица.Колонки.Добавить("СуммаНДСВзаиморасчетов", Новый ОписаниеТипов("Число"));
				Для Каждого СтрТаб Из пТаблица Цикл 
					СтрТаб.СуммаВзаиморасчетов	  = СтрТаб.СуммаРуб;
					СтрТаб.СуммаНДСВзаиморасчетов = СтрТаб.СуммаНДСРуб;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
		
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2019-01-28 (#3192)
		стрТаблицыДляПроведенияПоБК.ТаблицаНематериальныеАктивы.Колонки.СчетУчета.Имя = "Счет";
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2019-01-28 (#3192)
		
		ДополнительныеСвойства.Вставить("ТаблицыДокумента", стрТаблицыДляПроведенияПоБК);
		
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2019-01-23 (#3192)
		//ОК_ПодпискиНаСобытия.ок_ПроведениеПоАналитикамБК(ЭтотОбъект, Отказ, РежимПроведения);
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2019-01-23 (#3192)
				
	КонецЕсли;
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2018-07-09 (#3052)
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	РаздельныйУчетНДСНаСчете19 = УчетнаяПолитика.РаздельныйУчетНДСНаСчете19(Организация, Дата);
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если НЕ ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
	КонецЕсли;
	
	// В формах документа счет расчетов и счет авансов редактируются в специальной форме.
	// В случае, если они не заполнены, покажем сообщение возле соответствующей гиперссылки.

	МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаРасчетовСКонтрагентом");
	МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаРасчетовПоАвансам");

	Если НЕ ЗначениеЗаполнено(СчетУчетаРасчетовСКонтрагентом) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(,,
			НСтр("ru = 'Счет учета расчетов с контрагентом'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,,
			"ПорядокУчетаРасчетов", Отказ);
	КонецЕсли;
		
	Если СпособЗачетаАвансов <> Перечисления.СпособыЗачетаАвансов.НеЗачитывать Тогда 
		Если НЕ ЗначениеЗаполнено(СчетУчетаРасчетовПоАвансам) Тогда
			ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(,,
				НСтр("ru = 'Счет учета расчетов по авансам'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,,
				"ПорядокУчетаРасчетов", Отказ);
		КонецЕсли;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("НематериальныеАктивы.СчетУчетаНДС");
	Если Не НДСВключенВСтоимость Тогда
		
		Для Каждого СтрокаТаблицы Из НематериальныеАктивы Цикл 
			
			Префикс = "НематериальныеАктивы[%1].";
			Префикс = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				Префикс, Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ="));
			ИмяСписка = НСтр("ru = 'Нематериальные услуги'");

			Если СтрокаТаблицы.СуммаНДС <> 0 
				И НЕ ЗначениеЗаполнено(СтрокаТаблицы.СчетУчетаНДС) Тогда
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Счет НДС'"),
					СтрокаТаблицы.НомерСтроки, ИмяСписка);
				Поле = Префикс + "СчетУчетаНДС";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			//Проверка способа учета НДС
			Если РаздельныйУчетНДСНаСчете19 И НЕ ЗначениеЗаполнено(СтрокаТаблицы.СпособУчетаНДС)
				И СтрокаТаблицы.СуммаНДС <> 0 Тогда
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Способ учета НДС'"),
				СтрокаТаблицы.НомерСтроки, ИмяСписка);
				Поле = Префикс + "СпособУчетаНДС";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);	
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;
	
	// Табличная часть "Зачет авансов"
	Если СпособЗачетаАвансов <> Перечисления.СпособыЗачетаАвансов.ПоДокументу Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЗачетАвансов");
	ИначеЕсли ЗачетАвансов.Количество() = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЗачетАвансов");
	
		ТекстСообщения = НСтр("ru = 'Не введено ни одной строки с документом аванса!'");
		Поле = "ПорядокУчетаРасчетов";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , Поле, Отказ);
	КонецЕсли;
	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2018-07-16 (#3052)
	
	//пОбСтроительстваИзПодразделения = ПодразделениеОрганизации.ОК_ОбъектСтроительства;	
	//Для каждого пСтрокаТЧ Из НематериальныеАктивы Цикл
	//
	//	Если пСтрокаТЧ.НематериальныйАктив.бит_ОбъектСтроительства<>пОбСтроительстваИзПодразделения Тогда 
	//		ТекстСообщения = НСтр("ru = 'В строке %1 объект строительства, указанного НМА не соответствует объекту строительства из подразделения организации!'");
	//		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения,пСтрокаТЧ.НомерСтроки);
	//		Поле = "Объект.НематериальныеАктивы["+НематериальныеАктивы.Индекс(пСтрокаТЧ)+"].НематериальныйАктив";           			
	//		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , Поле, Отказ);
	//	КонецЕсли;		
	//			
	//КонецЦикла; 
	
	Если ДополнительныеСвойства.Свойство("ДополнительныеАналитики") И 
		 ДополнительныеСвойства.ДополнительныеАналитики.Получить("NЗАЯВКИ")<>Неопределено
	Тогда 
		
		пНомерЗаявки =  ДополнительныеСвойства.ДополнительныеАналитики["NЗАЯВКИ"];	
		
	Иначе 
		
		пНомерЗаявки = бит_МеханизмДопИзмерений.ПолучитьЗначениеДопАналитики(Ссылка,
									   	   ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.НайтиПоКоду("NЗАЯВКИ"), ПредопределенноеЗначение("Документ.бит_ФормаВводаБюджета.ПустаяСсылка"));
		
	КонецЕсли;
									   
	Если НЕ ЗначениеЗаполнено(пНомерЗаявки) Тогда 
		
		//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-09-17 (#3758)
		//пИменаРеквизитовТЧ = "ок_Период,ок_ЦФО,ок_СтатьяОборотов,ок_Аналитика_2";
		пИменаРеквизитовТЧ = "ок_Период,ок_ЦФО,ок_Аналитика_2";
		//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-09-17 (#3758)
		мИменаРеквизитовТЧ = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(пИменаРеквизитовТЧ,",");
				
		Для Каждого стрТЧ Из ЭтотОбъект["НематериальныеАктивы"] Цикл 
			Для Каждого пИмяРеквизитаТЧ Из мИменаРеквизитовТЧ Цикл 
				МассивНепроверяемыхРеквизитов.Добавить("НематериальныеАктивы." + пИмяРеквизитаТЧ);
			КонецЦикла;
		КонецЦикла;
		
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2019-01-10 (#3141)
	Иначе
		
		ЗапросПроверки = Новый Запрос;
		ЗапросПроверки.Текст = 
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ПроверяемыеДанные.НематериальныйАктив КАК Справочник.НематериальныеАктивы) КАК НематериальныйАктив,
		|	ПроверяемыеДанные.ок_Аналитика_2 КАК Аналитика_2,
		|	ПроверяемыеДанные.НомерСтроки КАК НомерСтроки
		|ПОМЕСТИТЬ ВТ0_ИсходныеДанные
		|ИЗ
		|	&ПроверяемыеДанные КАК ПроверяемыеДанные
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВТ0_ИсходныеДанные.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	ВТ0_ИсходныеДанные КАК ВТ0_ИсходныеДанные
		|ГДЕ
		|	ВТ0_ИсходныеДанные.НематериальныйАктив.бит_ОбъектСтроительства <> ВТ0_ИсходныеДанные.Аналитика_2
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ0_ИсходныеДанные.НомерСтроки
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
		ЗапросПроверки.УстановитьПараметр("ПроверяемыеДанные"	,	НематериальныеАктивы.Выгрузить(,"НематериальныйАктив,ок_Аналитика_2,НомерСтроки"));
		
		РезультатЗапроса = ЗапросПроверки.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ТекстСообщения = НСтр("ru = 'В строке %1 объект строительства НМА не соответствует указанному в строке!'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения,ВыборкаДетальныеЗаписи.НомерСтроки);
			Поле = "Объект.НематериальныеАктивы["+НематериальныеАктивы.Индекс(НематериальныеАктивы.Найти(ВыборкаДетальныеЗаписи.НомерСтроки,"НомерСтроки"))+"].НематериальныйАктив";           			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , Поле, Отказ);
		КонецЦикла;
	    //ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2019-01-10 (#3141)
		
	КонецЕсли;
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2018-07-16 (#3052)
	
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2019-10-19 (#3443)
	ОК_ОбщегоНазначения.ВыполнитьПроверкуОднозначногоСоответствияСтатьиОборотовИСтавкиНДСКСчету(ЭтотОбъект, ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ВложенияВоВнеоборотныеАктивы"), Отказ);
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2019-10-19 (#3443)
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("Проведен", ЭтотОбъект, "СчетФактураПолученный");	
	ПараметрыДействия.СостояниеФлага = Ложь;
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ);
	
	РаботаСПоследовательностями.ОтменитьРегистрациюВПоследовательности(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
		
	Если УчетнаяПолитика.РаздельныйУчетНДСНаСчете19(Организация, Дата) Тогда
		НДСВключенВСтоимость = Ложь;
	КонецЕсли;

	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСДоговорамиКонтрагентовБП.ЗаполнитьДоговорПередЗаписью(ЭтотОбъект);
	
	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДС(ЭтотОбъект);
	
	Если СпособЗачетаАвансов <> Перечисления.СпособыЗачетаАвансов.ПоДокументу 
		 И ЗачетАвансов.Количество() > 0 Тогда
		ЗачетАвансов.Очистить();
	КонецЕсли;
	
	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("ПометкаУдаления", ЭтотОбъект, "СчетФактураПолученный");
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ);
	
	Документы.КорректировкаПоступления.ОбновитьРеквизитыСвязанныхДокументовКорректировки(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
		УчетНДСПереопределяемый.СинхронизироватьРеквизитыСчетаФактурыПолученного(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
	ЗачетАвансов.Очистить();
	
	СтруктураКурсаВзаиморасчетов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(
	ВалютаДокумента, Дата);
	
	КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
	КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;
	
	//ОКЕЙ Вдовиченко Г.В(СофтЛаб) Начало 2019-08-05 (#3364)
	ОчищатьДанныеФВБ = ок_ОбменСКонтрагентамиВнутренний.ПолучитьПризнакОчисткиДанныхФВБВУчетномДокументеПриКопировании(ОбъектКопирования);
	//ОКЕЙ Вдовиченко Г.В(СофтЛаб) Конец 2019-08-05 (#3364)
	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2018-08-10 (#3052)	
	Для Каждого СтрНМА Из НематериальныеАктивы Цикл
		
		//ОКЕЙ Вдовиченко Г.В(СофтЛаб) Начало 2019-08-05 (#3364)
		Если Не ОчищатьДанныеФВБ Тогда
			Продолжить;
		КонецЕсли;	
		//ОКЕЙ Вдовиченко Г.В(СофтЛаб) Конец 2019-08-05 (#3364)
		
		СтрНМА.ок_Период 			= Неопределено;	
		СтрНМА.ок_ЦФО 				= Неопределено;	
		СтрНМА.ок_СтатьяОборотов 	= Неопределено;	
		СтрНМА.ок_Проект	 		= Неопределено;			
		СтрНМА.ок_Аналитика_2 		= Неопределено;			
		
	КонецЦикла;	
	ОК_ID_Разноска = Неопределено;
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2018-08-10 (#3052)
	
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2019-10-19 (#3443)
	ок_ВыгруженВAXAPTA = Ложь;
	ок_ВыгруженВAXAPTA_Актуальный = Ложь;
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2019-10-19 (#3443)	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли