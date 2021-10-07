﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// Организация

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Организация");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"РежимОтбораДокументов", ВидСравненияКомпоновкиДанных.Равно, Перечисления.РежимОтбораДокументов.ПоРеквизитам);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);


	// Организация

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Организация");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"РежимОтбораДокументов", ВидСравненияКомпоновкиДанных.НеРавно, Перечисления.РежимОтбораДокументов.ПоРеквизитам);

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Организация", ВидСравненияКомпоновкиДанных.НеЗаполнено);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);


	// СчетУчета

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СчетУчета");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"РежимОтбораДокументов", ВидСравненияКомпоновкиДанных.Равно, Перечисления.РежимОтбораДокументов.ПоОборотам);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);


	// СчетУчета

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СчетУчета");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"РежимОтбораДокументов", ВидСравненияКомпоновкиДанных.НеРавно, Перечисления.РежимОтбораДокументов.ПоРеквизитам);

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"СчетУчета", ВидСравненияКомпоновкиДанных.НеЗаполнено);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗагрузитьВТаблицуЗначений(ТаблицаИсточник, ТаблицаПриемник)

	Для Каждого СтрокаТаблицыИсточника Из ТаблицаИсточник Цикл

		СтрокаТаблицыПриемника = ТаблицаПриемник.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицыПриемника, СтрокаТаблицыИсточника);

	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьВедениеУчетаПоДокументамРасчетов(СчетУчета)
	
	ЕстьРасчетныеДокументы = Ложь;
	
	СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СчетУчета);
	
	Для Н = 1 По СвойстваСчета.КоличествоСубконто Цикл

		Если НЕ СвойстваСчета["ВидСубконто" + Н + "ТолькоОбороты"]
		   И СвойстваСчета["ВидСубконто" + Н] = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами Тогда
			ЕстьРасчетныеДокументы = Истина;
		КонецЕсли;

	КонецЦикла;
	
	Возврат ЕстьРасчетныеДокументы;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОграничениеСпискаДокументовПоТипу(Результат, ТипыДокументов)

	СтрокиКУдалению = Новый Массив();
	Результат.Колонки.Добавить("Сумма");
	Результат.Колонки.Добавить("Дата");
	Результат.Колонки.Добавить("Номер");
	Результат.Колонки.Добавить("ДатаВходящегоДокумента");
	Результат.Колонки.Добавить("НомерВходящегоДокумента");
	Результат.Колонки.Добавить("Проведен");
	Результат.Колонки.Добавить("ПометкаУдаления");
	Результат.Колонки.Добавить("СостояниеДокумента");
	Результат.Колонки.Добавить("ВидДокумента");
	Результат.Колонки.Добавить("ВидОперации");
	Результат.Колонки.Добавить("Валюта");
	Результат.Колонки.Добавить("Ответственный");
	
	ТаблицаТипов = Новый ТаблицаЗначений;
	ТаблицаТипов.Колонки.Добавить("ТипДокумента");
	ТаблицаТипов.Колонки.Добавить("ВидДокумента");
	ТаблицаТипов.Колонки.Добавить("НомерПараметра");
	ТаблицаТипов.Колонки.Добавить("МассивДокументов");
	ТаблицаТипов.Индексы.Добавить("ТипДокумента");
	
	ТекстЗапроса = "";
	НомерПараметра = 0;

	Для каждого СтрокаВыборки Из Результат Цикл

		Если НЕ ТипыДокументов.СодержитТип(ТипЗнч(СтрокаВыборки.Документ)) ИЛИ НЕ ЗначениеЗаполнено(СтрокаВыборки.Документ) Тогда
			СтрокиКУдалению.Добавить(СтрокаВыборки);
		Иначе
			ТипДокумента  	= ТипЗнч(СтрокаВыборки.Документ);
			СтрокаТипов 	= ТаблицаТипов.Найти(ТипДокумента, "ТипДокумента");	
			Если СтрокаТипов <> Неопределено Тогда
			    СтрокаТипов.МассивДокументов.Добавить(СтрокаВыборки.Документ);
			Иначе
				МД_Документа                     = Метаданные.НайтиПоТипу(ТипДокумента);
				
				НомерПараметра 					 = НомерПараметра + 1;
				
				СтрокаТипов 					 = ТаблицаТипов.Добавить();
				СтрокаТипов.ТипДокумента		 = ТипДокумента;
				СтрокаТипов.НомерПараметра		 = НомерПараметра;
				СтрокаТипов.ВидДокумента		 = МД_Документа.Представление();
				СтрокаТипов.МассивДокументов	 = Новый Массив;
				СтрокаТипов.МассивДокументов.Добавить(СтрокаВыборки.Документ);
				
				ЕстьСуммаДокумента	 = ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаДокумента", МД_Документа);
				ЕстьВидОперации		 = ОбщегоНазначения.ЕстьРеквизитОбъекта("ВидОперации",МД_Документа);
				ЕстьВалютаДокумента  = ОбщегоНазначения.ЕстьРеквизитОбъекта("ВалютаДокумента",МД_Документа);
				ЕстьОтветственный	 = ОбщегоНазначения.ЕстьРеквизитОбъекта("Ответственный",МД_Документа);
				ЕстьВхДата			 = ОбщегоНазначения.ЕстьРеквизитОбъекта("ДатаВходящегоДокумента",МД_Документа);
				ЕстьВхНомер			 = ОбщегоНазначения.ЕстьРеквизитОбъекта("НомерВходящегоДокумента",МД_Документа);
				Если НЕ ПустаяСтрока(ТекстЗапроса) Тогда
					ТекстЗапроса = ТекстЗапроса +
					"
					|
					|ОБЪЕДИНИТЬ ВСЕ
					|
					|";
				КонецЕсли;
				
				ТекстЗапроса = ТекстЗапроса + 
				"ВЫБРАТЬ
				|	Док.Ссылка,
				|	Док.Дата,
				|	Док.Номер,
				|	Док.Проведен,
				|	Док.ПометкаУдаления,
				|	" + ?(ЕстьСуммаДокумента, 	"Док.СуммаДокумента",			"0")			+ " КАК Сумма,
				|	" + ?(ЕстьВидОперации, 		"Док.ВидОперации",				"Неопределено") + " КАК ВидОперации,
				|	" + ?(ЕстьВалютаДокумента, 	"Док.ВалютаДокумента",			"Неопределено") + " КАК ВалютаДокумента,
				|	" + ?(ЕстьВхДата, 			"Док.ДатаВходящегоДокумента",	"Неопределено") + " КАК ДатаВходящегоДокумента,
				|	" + ?(ЕстьВхНомер, 			"Док.НомерВходящегоДокумента",	"Неопределено") + " КАК НомерВходящегоДокумента,
				|	" + ?(ЕстьОтветственный, 	"Док.Ответственный",			"Неопределено") + " КАК Ответственный
				|ИЗ
				|	Документ." + МД_Документа.Имя + " КАК Док
				|ГДЕ
				|	Док.Ссылка В (&СписокДокументов" + Формат(НомерПараметра, "ЧГ=") + ")
				|";
				
			КонецЕсли;
		КонецЕсли;

	КонецЦикла;

	Для Каждого СтрокаВыборки Из СтрокиКУдалению Цикл
		Результат.Удалить(СтрокаВыборки);
	КонецЦикла;
	
	Если Результат.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	// Установим параметры запроса 
	Для Каждого СтрокаТаблицы Из ТаблицаТипов Цикл
		Запрос.УстановитьПараметр("СписокДокументов" + Формат(СтрокаТаблицы.НомерПараметра, "ЧГ="), СтрокаТаблицы.МассивДокументов);
	КонецЦикла;
	
	ТаблицаДокументов = Запрос.Выполнить().Выгрузить();
	ТаблицаДокументов.Индексы.Добавить("Ссылка");
	
	Для каждого СтрокаВыборки Из Результат Цикл

		СтрокаДокумента = ТаблицаДокументов.Найти(СтрокаВыборки.Документ, "Ссылка");
		Если СтрокаДокумента <> Неопределено Тогда
			СтрокаВыборки.Сумма						 = СтрокаДокумента.Сумма;
			СтрокаВыборки.Дата						 = СтрокаДокумента.Дата;
			СтрокаВыборки.Номер						 = СтрокаДокумента.Номер;
			СтрокаВыборки.НомерВходящегоДокумента	 = СтрокаДокумента.НомерВходящегоДокумента;
			СтрокаВыборки.ДатаВходящегоДокумента	 = СтрокаДокумента.ДатаВходящегоДокумента;
			СтрокаВыборки.Проведен					 = СтрокаДокумента.Проведен;
			СтрокаВыборки.ПометкаУдаления			 = СтрокаДокумента.ПометкаУдаления;
			СтрокаВыборки.СостояниеДокумента		 = ?(СтрокаДокумента.ПометкаУдаления, 2, ?(СтрокаДокумента.Проведен, 1, 0));
			СтрокаВыборки.ВидОперации				 = СтрокаДокумента.ВидОперации;
			СтрокаВыборки.Валюта					 = СтрокаДокумента.ВалютаДокумента;
			СтрокаВыборки.Ответственный				 = СтрокаДокумента.Ответственный;
		КонецЕсли;

		СтрокаТипов = ТаблицаТипов.Найти(ТипЗнч(СтрокаВыборки.Документ), "ТипДокумента");
		Если СтрокаТипов <> Неопределено Тогда
			СтрокаВыборки.ВидДокумента		 = СтрокаТипов.ВидДокумента;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеСпискаПоРеквизитам(СтруктураОтбора)
	
	НачПериода         = СтруктураОтбора["НачПериода"];
	КонПериода         = СтруктураОтбора["КонПериода"];
	Организация        = СтруктураОтбора["Организация"];
	Контрагент         = СтруктураОтбора["Контрагент"];
	ДоговорКонтрагента = СтруктураОтбора["ДоговорКонтрагента"];
	ТипыДокументов     = СтруктураОтбора["ТипыДокументов"];
	
	//Формирование текста запроса
	Если ЗначениеЗаполнено(Организация) тогда
		УсловиеЗапросаОрганизация = " И Док.Организация = &Организация ";
	КонецЕсли;
	Если ЗначениеЗаполнено(Контрагент) тогда
		УсловиеЗапросаКонтрагент = " И Док.Контрагент = &Контрагент ";
	КонецЕсли;
	
	ТекстЗапроса = "";
	
	Для Каждого ТипДокумента Из ТипыДокументов.Типы() Цикл
		МД_Документа = Метаданные.НайтиПоТипу(ТипДокумента);
		Если не ПустаяСтрока(УсловиеЗапросаОрганизация) и МД_Документа.Реквизиты.Найти("Организация")=Неопределено Тогда
			//В документе нет поля "Организация". Отбор по документу не производим.
			Продолжить;
		КонецЕслИ;
	
		Если не ПустаяСтрока(УсловиеЗапросаКонтрагент) 
			и  МД_Документа.Реквизиты.Найти("Контрагент")=Неопределено Тогда
			//В документе нет поля "Контрагент".  Отбор по документу не производим.
			Продолжить;
		КонецЕсли;
		
		Если не ПустаяСтрока(ТекстЗапроса) Тогда
			ТекстЗапроса = ТекстЗапроса +"
			|
			| ОБЪЕДИНИТЬ ВСЕ 
			|";
		КонецЕсли;
		
		ЕстьСуммаДокумента	 = ОбщегоНазначения.ЕстьРеквизитОбъекта("СуммаДокумента", МД_Документа);
		ЕстьВидОперации		 = ОбщегоНазначения.ЕстьРеквизитОбъекта("ВидОперации",МД_Документа);
		ЕстьВалютаДокумента  = ОбщегоНазначения.ЕстьРеквизитОбъекта("ВалютаДокумента",МД_Документа);
		ЕстьОтветственный	 = ОбщегоНазначения.ЕстьРеквизитОбъекта("Ответственный",МД_Документа);
		ЕстьВхДата			 = ОбщегоНазначения.ЕстьРеквизитОбъекта("ДатаВходящегоДокумента",МД_Документа);
		ЕстьВхНомер			 = ОбщегоНазначения.ЕстьРеквизитОбъекта("НомерВходящегоДокумента",МД_Документа);
		ВидДокумента		 = МД_Документа.Представление();
		
		ТекстЗапроса = ТекстЗапроса +  "ВЫБРАТЬ" + ?(ПустаяСтрока(ТекстЗапроса), " РАЗРЕШЕННЫЕ","") + "
		|	Док.Ссылка КАК Документ,
		|	Док.Дата,
		|	Док.Номер,
		|	Док.Проведен,
		|	Док.ПометкаУдаления,
		|	ВЫБОР КОГДА Док.ПометкаУдаления ТОГДА 2 КОГДА Док.Проведен ТОГДА 1 ИНАЧЕ 0 КОНЕЦ КАК СостояниеДокумента,
		|	""" + СтрЗаменить(ВидДокумента, """", """""") + """ КАК ВидДокумента, 
		|	" + ?(ЕстьСуммаДокумента, 	"Док.СуммаДокумента",			"0")			+ " КАК Сумма,
		|	" + ?(ЕстьВидОперации, 		"Док.ВидОперации",				"Неопределено") + " КАК ВидОперации,
		|	" + ?(ЕстьВалютаДокумента, 	"Док.ВалютаДокумента",			"Неопределено") + " КАК Валюта,
		|	" + ?(ЕстьВхДата, 			"Док.ДатаВходящегоДокумента",	"Неопределено") + " КАК ДатаВходящегоДокумента,
		|	" + ?(ЕстьВхНомер, 			"Док.НомерВходящегоДокумента",	"Неопределено") + " КАК НомерВходящегоДокумента,
		|	" + ?(ЕстьОтветственный, 	"Док.Ответственный",			"Неопределено") + " КАК Ответственный
		|ИЗ
		|	Документ." + МД_Документа.Имя + " КАК Док
		|ГДЕ
		|	(Док.Дата >= &НачПериода "+?(НЕ ЗначениеЗаполнено(КонПериода),""," И Док.Дата <= &КонПериода")+")
		|";
		
		ТекстЗапроса = ТекстЗапроса +  УсловиеЗапросаОрганизация;
		ТекстЗапроса = ТекстЗапроса +  УсловиеЗапросаКонтрагент;
	
	КонецЦикла; 
	
	Если ПустаяСтрока(ТекстЗапроса) Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	ТекстЗапроса = ТекстЗапроса + "
	|	УПОРЯДОЧИТЬ ПО Дата, Документ";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачПериода",			НачалоДня(НачПериода));
	Запрос.УстановитьПараметр("КонПериода",			КонПериода);
	Запрос.УстановитьПараметр("Организация",		Организация);
	Запрос.УстановитьПараметр("Контрагент",			Контрагент);
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить().Выгрузить();
	
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ЗапросДокументовПоДоговору = Новый Запрос;
		ЗапросДокументовПоДоговору.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДокументыПоДоговоруКонтрагента.Ссылка
		|ИЗ
		|	КритерийОтбора.ДокументыПоДоговоруКонтрагента(&ДоговорКонтрагента) КАК ДокументыПоДоговоруКонтрагента";
		ЗапросДокументовПоДоговору.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
		ТаблицаДокументовПоДоговору = ЗапросДокументовПоДоговору.Выполнить().Выгрузить();
		МассивДокументовПоДоговору  = ТаблицаДокументовПоДоговору.ВыгрузитьКолонку("Ссылка");
		
		СтрокиКУдалению = Новый Массив;
		Для каждого СтрокаТаблицы Из Результат Цикл
			Если МассивДокументовПоДоговору.Найти(СтрокаТаблицы.Документ) = Неопределено Тогда
				СтрокиКУдалению.Добавить(СтрокаТаблицы);
			КонецЕсли; 
		КонецЦикла;
		Для каждого СтрокаКУдалению Из СтрокиКУдалению Цикл
			Результат.Удалить(СтрокаКУдалению);
		КонецЦикла; 
	КонецЕсли; 

	Возврат Результат;

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеСпискаПоОстаткам(СтруктураОтбора)

	НачПериода         = СтруктураОтбора["НачПериода"];
	КонПериода         = СтруктураОтбора["КонПериода"];
	Организация        = СтруктураОтбора["Организация"];
	Контрагент         = СтруктураОтбора["Контрагент"];
	ДоговорКонтрагента = СтруктураОтбора["ДоговорКонтрагента"];
	Счет               = СтруктураОтбора["Счет"];
	ОстаткиОбороты     = СтруктураОтбора["ОстаткиОбороты"];
	ТипыДокументов     = СтруктураОтбора["ТипыДокументов"];
	ВестиУчетПоДоговорам = ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонПериода",  КонПериода);
	Запрос.УстановитьПараметр("Организация", Организация);

	УсловиеЗапроса = "Организация = &Организация";

	ОпределениеДокументаСделки = "";
	ВидыСубконто               = Новый Массив;

	ИмяРегистра                = "Хозрасчетный";
	ЕстьРасчетныеДокументы     = Ложь;
	
	СвойстваСчета	   = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет);
	
	Для Н = 1 По СвойстваСчета.КоличествоСубконто Цикл

		Если НЕ СвойстваСчета["ВидСубконто" + Н + "ТолькоОбороты"] Тогда

			ВидСубконто = СвойстваСчета["ВидСубконто" + Н];
			ВидыСубконто.Добавить(ВидСубконто);

			Если ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты Тогда
				УсловиеЗапроса = УсловиеЗапроса + " И Субконто" + Н + " = &субконто" + Н;
				Запрос.УстановитьПараметр("Субконто" + Н, Контрагент);
			ИначеЕсли ВестиУчетПоДоговорам И ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры Тогда
				УсловиеЗапроса = УсловиеЗапроса + " И Субконто" + Н + " = &субконто" + Н;
				Запрос.УстановитьПараметр("Субконто" + Н, ДоговорКонтрагента);
			ИначеЕсли ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами Тогда
				ОпределениеДокументаСделки = "Выборка.Субконто" + Н + " КАК Документ,";
				ЕстьРасчетныеДокументы = Истина;
			КонецЕсли;

		КонецЕсли;

	КонецЦикла;

	Запрос.УстановитьПараметр("ВидыСубконто", ВидыСубконто);
	
	Если НЕ ЕстьРасчетныеДокументы Тогда
		ОпределениеДокументаСделки = "Неопределено КАК Документ,";
	КонецЕсли; 

	Если ЗначениеЗаполнено(Счет) Тогда
		Запрос.УстановитьПараметр("Счет", БухгалтерскийУчетПовтИсп.СчетаВИерархии(Счет));
		УсловиеВыбораСчетаВТекстеЗапроса = "Счет В (&Счет)";
	Иначе 
		УсловиеВыбораСчетаВТекстеЗапроса = "";
	КонецЕсли;

	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	" + ОпределениеДокументаСделки + "
	|	Выборка.СуммаОстаток" + ОстаткиОбороты + " КАК Остаток
	|ИЗ
	|	РегистрБухгалтерии." + ИмяРегистра + ".Остатки(&КонПериода, "+ УсловиеВыбораСчетаВТекстеЗапроса + ", &ВидыСубконто, " + УсловиеЗапроса + ") КАК Выборка";

	Результат = Запрос.Выполнить().Выгрузить();
	
	Если ЕстьРасчетныеДокументы Тогда
		ОграничениеСпискаДокументовПоТипу(Результат, ТипыДокументов);
		Результат.Сортировать("Дата, Документ", Новый СравнениеЗначений);
	Иначе
		Результат.Очистить();
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеСпискаПоОборотам(СтруктураОтбора)

	НачПериода         = СтруктураОтбора["НачПериода"];
	КонПериода         = СтруктураОтбора["КонПериода"];
	Организация        = СтруктураОтбора["Организация"];
	Контрагент         = СтруктураОтбора["Контрагент"];
	ДоговорКонтрагента = СтруктураОтбора["ДоговорКонтрагента"];
	Счет               = СтруктураОтбора["Счет"];
	ОстаткиОбороты     = СтруктураОтбора["ОстаткиОбороты"];
	ТипыДокументов     = СтруктураОтбора["ТипыДокументов"];
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачПериода", НачалоДня(НачПериода));
	Запрос.УстановитьПараметр("КонПериода", КонПериода);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
	
	УсловиеЗапроса = "Организация = &Организация";
	
	ЕстьРасчетныеДокументы = Ложь;
	ОпределениеДокументаСделки = "";
	ВидыСубконто = Новый Массив;
	
	ИспользованоСубконто = 0; 
	
	ИмяРегистра = "Хозрасчетный";
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		ИспользованоСубконто = ИспользованоСубконто + 1;
		ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
		УсловиеЗапроса = УсловиеЗапроса+ " И Субконто" + ИспользованоСубконто + " = &Контрагент";
	КонецЕсли;
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ИспользованоСубконто = ИспользованоСубконто+1;
		ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
		УсловиеЗапроса = УсловиеЗапроса + " И Субконто" + ИспользованоСубконто + " = &ДоговорКонтрагента";
	КонецЕсли;
	Если ЗначениеЗаполнено(Счет) Тогда
		Если БухгалтерскийУчет.НаСчетеВедетсяУчетПоДокументамРасчетов(Счет) Тогда
			ИспользованоСубконто = ИспользованоСубконто + 1;
			ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами);
			ЕстьРасчетныеДокументы = Истина;
			ОпределениеДокументаСделки = "Выборка.Субконто" + ИспользованоСубконто + " КАК Документ";
		КонецЕсли;
	КонецЕсли;
	
	РежимОпределенияОборотов = "Период";
	Если НЕ ЕстьРасчетныеДокументы тогда
		РежимОпределенияОборотов = "Регистратор";
		ОпределениеДокументаСделки = "Выборка.Регистратор как Документ";
	КонецЕсли;

	Запрос.УстановитьПараметр("ВидыСубконто", ВидыСубконто);

	Если ЗначениеЗаполнено(Счет) Тогда
		Запрос.УстановитьПараметр("Счет", БухгалтерскийУчетПовтИсп.СчетаВИерархии(Счет));
		УсловиеВыбораСчетаВТекстеЗапроса = "Счет В (&Счет)";
	Иначе
		УсловиеВыбораСчетаВТекстеЗапроса = "";
	КонецЕсли;

	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	" + ОпределениеДокументаСделки + ",
	|	Выборка.СуммаОборот" + ОстаткиОбороты + " КАК Оборот,
	|	Выборка.СуммаКонечныйОстаток" + ОстаткиОбороты + " КАК Остаток
	|ИЗ
	|	РегистрБухгалтерии." + ИмяРегистра + ".ОстаткиИОбороты(&НачПериода, &КонПериода, " + РежимОпределенияОборотов + ",, " + УсловиеВыбораСчетаВТекстеЗапроса + ", &ВидыСубконто, " + УсловиеЗапроса + ") КАК Выборка
	|ГДЕ НЕ (Выборка.СуммаОборот" + ОстаткиОбороты + " = 0)
	|";

	Результат = Запрос.Выполнить().Выгрузить();

	// При отсутствии расчетных документов необходимо дополнить список ручными документами по контрагенту
	Если НЕ ЕстьРасчетныеДокументы тогда
		// Преопределение типов для колонки "Документ" (т.к. в типе только регистраторы, а РД не проводится).
		СписокДокументов = Результат.ВыгрузитьКолонку("Документ");
		Результат.Колонки.Удалить(Результат.Колонки.документ);
		Результат.Колонки.Вставить(0, "Документ", ТипыДокументов);
		Результат.ЗагрузитьКолонку(СписокДокументов, "Документ");
		
		ИспользованоСубконто = ИспользованоСубконто + 1;
		ОпределениеДокументаСделки = "Выборка.Субконто" + ИспользованоСубконто + " КАК Документ";
		
		ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами);
		
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	" + ОпределениеДокументаСделки + ",
		|	Выборка.СуммаОборот" + ОстаткиОбороты + " КАК Оборот,
		|	Выборка.СуммаКонечныйОстаток" + ОстаткиОбороты +" КАК Остаток
		|ИЗ
		|	РегистрБухгалтерии." + ИмяРегистра + ".ОстаткиИОбороты(&НачПериода, &КонПериода, " + РежимОпределенияОборотов + ",, "+ УсловиеВыбораСчетаВТекстеЗапроса + ", &ВидыСубконто, " + УсловиеЗапроса + ") КАК Выборка
		|ГДЕ НЕ (Выборка.СуммаОборот" + ОстаткиОбороты + " = 0)
		|";

		РезультатДляРД = Запрос.Выполнить().Выгрузить();
		Для Каждого ДокументДопЗапроса Из РезультатДляРД Цикл
		    Если ТипЗнч(ДокументДопЗапроса.Документ) = Тип("ДокументСсылка.ДокументРасчетовСКонтрагентом") Тогда
			    СтрокаРезультатов = Результат.Добавить();
				СтрокаРезультатов.Документ = ДокументДопЗапроса.Документ;
			КонецЕсли; 
		КонецЦикла; 
	КонецЕсли;	

	Если НЕ ЕстьРасчетныеДокументы Тогда
		Результат.Свернуть("Документ","");
	Иначе
		Результат.Колонки.Удалить(Результат.Колонки.Оборот);
	КонецЕсли;

	ОграничениеСпискаДокументовПоТипу(Результат, ТипыДокументов);
	Результат.Сортировать("Дата, Документ", Новый СравнениеЗначений);

	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	ДоступностьСчета = (Форма.РежимОтбораДокументов <> ПредопределенноеЗначение("Перечисление.РежимОтбораДокументов.ПоРеквизитам"));
	
	Форма.Элементы.СчетУчета.Доступность      = ДоступностьСчета;
	Форма.Элементы.ОстаткиОбороты.Доступность = ДоступностьСчета;
	Форма.Элементы.СписокОстаток.Видимость    = ДоступностьСчета;
	
	Если Форма.РежимОтбораДокументов = ПредопределенноеЗначение("Перечисление.РежимОтбораДокументов.ПоОстаткам") Тогда
		Форма.Элементы.ОстаткиОбороты.Заголовок = НСтр("ru = 'Остатки'");
		Форма.Элементы.СписокОстаток.Заголовок  = НСтр("ru = 'Остаток'");
		
	ИначеЕсли Форма.РежимОтбораДокументов = ПредопределенноеЗначение("Перечисление.РежимОтбораДокументов.ПоОборотам") Тогда
		Форма.Элементы.ОстаткиОбороты.Заголовок = НСтр("ru = 'Обороты'");
		Форма.Элементы.СписокОстаток.Заголовок  = НСтр("ru = 'Оборот'");
	Иначе
		Форма.Элементы.ОстаткиОбороты.Заголовок = НСтр("ru = 'Ост./об.'");
		Форма.Элементы.СписокОстаток.Заголовок  = НСтр("ru = 'Остаток (оборот)'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимОтбораПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимОтбораОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаПриИзменении(Элемент)
	
	СчетУчетаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСервер()
	
	Список.Очистить();

	Если РежимОтбораДокументов = Перечисления.РежимОтбораДокументов.ПоРеквизитам Тогда
		
		СтруктураОтбора = Новый Структура("НачПериода, КонПериода, Организация, Контрагент, ДоговорКонтрагента, ТипыДокументов",
		                                  НачалоПериода,
		                                  КонецПериода,
		                                  Организация,
		                                  Контрагент,
		                                  ДоговорКонтрагента,
										  ТипыДокументов);
	
		ТаблицаИсточник = ПолучитьДанныеСпискаПоРеквизитам(СтруктураОтбора);
		
		Если НЕ ТаблицаИсточник = Неопределено Тогда
			ЗагрузитьВТаблицуЗначений(ТаблицаИсточник, Список);
		КонецЕсли;
		
	ИначеЕсли РежимОтбораДокументов = Перечисления.РежимОтбораДокументов.ПоОстаткам Тогда
		
		СтруктураОтбора = Новый Структура("НачПериода, КонПериода, Организация, Контрагент, ДоговорКонтрагента, Счет, ОстаткиОбороты, ТипыДокументов",
		                                  НачалоПериода,
		                                  КонецПериода,
		                                  Организация,
		                                  Контрагент,
		                                  ДоговорКонтрагента,
		                                  СчетУчета,
		                                  ОстаткиОбороты,
		                                  ТипыДокументов);
										  
		ТаблицаИсточник = ПолучитьДанныеСпискаПоОстаткам(СтруктураОтбора);
		
		Если НЕ ТаблицаИсточник = Неопределено Тогда
			ЗагрузитьВТаблицуЗначений(ТаблицаИсточник, Список);
		КонецЕсли;
		
	ИначеЕсли РежимОтбораДокументов = Перечисления.РежимОтбораДокументов.ПоОборотам Тогда
		
		СтруктураОтбора = Новый Структура("НачПериода, КонПериода, Организация, Контрагент, ДоговорКонтрагента, Счет, ОстаткиОбороты, ТипыДокументов",
		                                  НачалоПериода,
		                                  КонецПериода,
		                                  Организация,
		                                  Контрагент,
		                                  ДоговорКонтрагента,
		                                  СчетУчета,
		                                  ОстаткиОбороты,
		                                  ТипыДокументов);
										  
		ТаблицаИсточник = ПолучитьДанныеСпискаПоОборотам(СтруктураОтбора);
		
		Если НЕ ТаблицаИсточник = Неопределено Тогда
			ЗагрузитьВТаблицуЗначений(ТаблицаИсточник, Список);
		КонецЕсли;
		
	КонецЕсли;
	
	ОпределитьМоментАктуальностиОтложенныхРасчетов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		СтандартнаяОбработка = Ложь;
		Возврат; 
	КонецЕсли;

	ТекущийДокумент = ТекущиеДанные.Документ;
	Если НЕ ЗначениеЗаполнено(ТекущийДокумент) Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	ОповеститьОВыборе(ТекущийДокумент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Дата", КонецПериода);
	ЗначенияЗаполнения.Вставить("Организация", Организация);
	ЗначенияЗаполнения.Вставить("Контрагент", Контрагент);
	ЗначенияЗаполнения.Вставить("ДоговорКонтрагента", ДоговорКонтрагента);
	
	ОткрытьФорму("Документ.ДокументРасчетовСКонтрагентом.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат; 
	КонецЕсли;

	ТекущийДокумент = ТекущиеДанные.Документ;
	Если НЕ ЗначениеЗаполнено(ТекущийДокумент) Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение( , ТекущийДокумент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОстаткиОбороты = "Дт";
	
	Если Параметры.Свойство("Отбор") Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.Отбор);
	КонецЕсли;
	
	НачалоПериодаУстановлено = Ложь;
	Если Параметры.Свойство("ПараметрыОбъекта") Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.ПараметрыОбъекта);
		Если Параметры.ПараметрыОбъекта.Свойство("Дата") Тогда
			Если Параметры.ПараметрыОбъекта.Дата = НачалоДня(Параметры.ПараметрыОбъекта.Дата) Тогда
				КонецПериода = КонецДня(Параметры.ПараметрыОбъекта.Дата);
			Иначе
				КонецПериода = Параметры.ПараметрыОбъекта.Дата - 1;
			КонецЕсли;
		КонецЕсли;
		НачалоПериодаУстановлено = Параметры.ПараметрыОбъекта.Свойство("НачалоПериода");
		Если Параметры.ПараметрыОбъекта.Свойство("ТипыДокументов") Тогда
			Если ТипЗнч(Параметры.ПараметрыОбъекта.ТипыДокументов) = Тип("Строка") Тогда
				ТипыДокументов = Вычислить(Параметры.ПараметрыОбъекта.ТипыДокументов);
			Иначе
				ТипыДокументов = Параметры.ПараметрыОбъекта.ТипыДокументов;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// КонПериода
	Если НЕ ЗначениеЗаполнено(КонецПериода) Тогда
		КонецПериода = КонецМесяца(ТекущаяДатаСеанса());
	КонецЕсли;

	// НачПериода
	Если НЕ НачалоПериодаУстановлено Тогда
		НачалоПериода = НачалоМесяца(КонецПериода);
	КонецЕсли;
	
	// РежимОтбора
	Если НЕ ЗначениеЗаполнено(РежимОтбораДокументов) Тогда
		РежимОтбораДокументов = Перечисления.РежимОтбораДокументов.ПоРеквизитам;
	Иначе
		СохранятьРежимОтбораДокументов = Ложь;
		ФормироватьСписокПриОткрытии   = Истина;
		Элементы.СохранятьРежимОтбораДокументов.Видимость = Ложь;
		Элементы.ФормироватьСписокПриОткрытии.Видимость   = Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТипыДокументов) тогда
		ТипыДокументов = Новый ОписаниеТипов("ДокументСсылка.ДокументРасчетовСКонтрагентом");
	КонецЕсли;
	
	Если СчетУчета = Неопределено Тогда
		СчетУчета = ПланыСчетов.Хозрасчетный.ПустаяСсылка();		
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам") Тогда
		ДоговорКонтрагента = Неопределено;
		Элементы.ДоговорКонтрагента.Видимость = Ложь;
	КонецЕсли;

	ИспользуетсяОтложенноеПроведение = ПолучитьФункциональнуюОпцию("ИспользоватьОтложенноеПроведение");
	Если ИспользуетсяОтложенноеПроведение Тогда
		СчетаВзаиморасчетов = УчетВзаиморасчетовОтложенноеПроведение.СчетаВзаиморасчетовПоддерживающиеОтложенноеПроведение();
		СчетаВзаиморасчетовСОтложеннымПроведением = Новый ФиксированныйМассив(СчетаВзаиморасчетов);
	КонецЕсли;
	
	Элементы.СписокОстаток.Видимость = ПроверитьВедениеУчетаПоДокументамРасчетов(СчетУчета);
	
	Если ФормироватьСписокПриОткрытии тогда
		СформироватьСервер();
	Иначе
		ОпределитьМоментАктуальностиОтложенныхРасчетов();
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма); 
	
	УстановитьУсловноеОформление();

	ДоступныеОрганизации = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(Истина);
	
	ЕстьДоступНаИзменение = ПравоДоступа("Изменение", Метаданные.РегистрыБухгалтерии.Хозрасчетный)
		И ДоступныеОрганизации.Найти(Организация) <> Неопределено;
		
	Элементы.Актуализировать.Видимость = ЕстьДоступНаИзменение;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если РежимОтбораДокументов = Перечисления.РежимОтбораДокументов.ПоРеквизитам Тогда
		
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Организация"));
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("СчетУчета"));
		
	ИначеЕсли РежимОтбораДокументов = Перечисления.РежимОтбораДокументов.ПоОстаткам
	        И ЗначениеЗаполнено(СчетУчета) 
	        И НЕ ПроверитьВедениеУчетаПоДокументамРасчетов(СчетУчета) Тогда
			
		ТекстСообщения = НСтр("ru = 'На счете не ведется учет по расчетным документам! Выбор по остаткам на счете не может использоваться.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "СчетУчета",, Отказ);	
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	ОповеститьОВыборе(НовыйОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	Если НЕ СохранятьРежимОтбораДокументов Тогда
		Настройки.Удалить("РежимОтбораДокументов");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Параметры.Свойство("РежимОтбораДокументов") Тогда
		Настройки.Очистить();
		Возврат;
	КонецЕсли;
	
	НастройкиИзменены = Ложь;
	
	Если ЗначениеЗаполнено(Настройки["РежимОтбораДокументов"]) Тогда
		Если РежимОтбораДокументов <> Настройки["РежимОтбораДокументов"] Тогда
			РежимОтбораДокументов = Настройки["РежимОтбораДокументов"]; // Используется в УправлениеФормой() и СформироватьСервер()
			УправлениеФормой(ЭтаФорма);
			НастройкиИзменены = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Настройки["ФормироватьСписокПриОткрытии"] = Истина Тогда
		// Обновляем список, если он не был ранее сформирован ПриСозданииНаСервере()
		// или загруженные настройки отличаются.
		Если НЕ ФормироватьСписокПриОткрытии ИЛИ НастройкиИзменены Тогда
			СформироватьСервер();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	Если ВозможныОтложенныеРасчеты(ЭтотОбъект) Тогда
		ОпределитьМоментАктуальностиОтложенныхРасчетов();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ВозможныОтложенныеРасчеты(ЭтотОбъект) Тогда
		ОпределитьМоментАктуальностиОтложенныхРасчетов();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	Если ВозможныОтложенныеРасчеты(ЭтотОбъект) Тогда
		ОпределитьМоментАктуальностиОтложенныхРасчетов();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)

	Если ВозможныОтложенныеРасчеты(ЭтотОбъект) Тогда
		ОпределитьМоментАктуальностиОтложенныхРасчетов();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Актуализировать(Команда)
	
	Если ЗначениеЗаполнено(ИдентификаторЗаданияОтложенныеРасчеты)
		И НЕ ЗаданиеВыполнено(ИдентификаторЗаданияОтложенныеРасчеты) Тогда
		// Задание запущено и еще не завершилось, продолжаем ожидание.
		Возврат;
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеОтложенныхРасчетов");
	
	ЗаданиеВыполнено = ЗапуститьОтложенныеРасчетыНаСервере();
	Если ЗаданиеВыполнено Тогда
		ПоказатьРезультатОтложенногоРасчета();
	Иначе
		ОжидатьВыполнениеОтложенныхРасчетов();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СкрытьПриНеобходимостиАктуализацииНажатие(Элемент)

	// Пользователь хочет скрыть данные по актуализации, сбрасываем соответствующие признаки.
	МоментАктуальностиОтложенныхРасчетов = Неопределено;
	УстановитьВидимостьЭлементовОжиданияОтложенныеРасчеты();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьАктуализацию(Команда)
	
	Если ЗначениеЗаполнено(ИдентификаторЗаданияОтложенныеРасчеты) Тогда
		ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеОтложенныхРасчетов");
		ОтменитьВыполнениеЗадания(ИдентификаторЗаданияОтложенныеРасчеты);
		ИдентификаторЗаданияОтложенныеРасчеты = Неопределено;
	КонецЕсли;
	
	ОпределитьМоментАктуальностиОтложенныхРасчетов();

КонецПроцедуры

&НаСервере
Процедура СчетУчетаПриИзмененииНаСервере()
	
	Элементы.СписокОстаток.Видимость = ПроверитьВедениеУчетаПоДокументамРасчетов(СчетУчета);
	
	ОпределитьМоментАктуальностиОтложенныхРасчетов();
	
КонецПроцедуры

#КонецОбласти

#Область ОтложенныеРасчеты

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(Знач ИдентификаторЗадания)

	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(Знач ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВозможныОтложенныеРасчеты(Форма)

	Если НЕ Форма.ИспользуетсяОтложенноеПроведение Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Форма.Организация) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Форма.СчетУчета)
		И Форма.СчетаВзаиморасчетовСОтложеннымПроведением.Найти(Форма.СчетУчета) = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;

КонецФункции

&НаСервере
Функция ДатаОкончанияАктуализации()

	Возврат ?(ЗначениеЗаполнено(КонецПериода), КонецПериода, ТекущаяДатаСеанса());

КонецФункции

&НаСервере
Процедура ОпределитьМоментАктуальностиОтложенныхРасчетов()

	МоментАктуальностиОтложенныхРасчетов = Неопределено;

	Если ВозможныОтложенныеРасчеты(ЭтотОбъект) Тогда
		
		МоментАктуальностиОтложенныхРасчетов = УчетВзаиморасчетовОтложенноеПроведение.МоментАктуальностиОтложенныхРасчетов(
			Организация,
			ДатаОкончанияАктуализации(),
			Контрагент,
			ДоговорКонтрагента);
			
		Элементы.ТекстПриНеобходимостиАктуализации.Заголовок =
			УчетВзаиморасчетовОтложенноеПроведение.ТекстПриНеобходимостиАктуализации(МоментАктуальностиОтложенныхРасчетов);
	
	КонецЕсли;
	
	УстановитьВидимостьЭлементовОжиданияОтложенныеРасчеты();

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовОжиданияОтложенныеРасчеты()

	УчетВзаиморасчетовОтложенноеПроведение.УстановитьВидимостьЭлементовОжиданияОтложенныеРасчеты(
		ЭтотОбъект, ДатаОкончанияАктуализации(), Ложь);

КонецПроцедуры

&НаСервере
Функция ЗапуститьОтложенныеРасчетыНаСервере()

	ЗаданиеВыполнено = Ложь;

	ИдентификаторЗаданияОтложенныеРасчеты = Неопределено;
	АдресХранилищаСОшибками = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	ПараметрыРасчета = УчетВзаиморасчетовОтложенноеПроведение.НовыеПараметрыРасчета();
	ПараметрыРасчета.Организация        = Организация;
	ПараметрыРасчета.ДатаОкончания      = ДатаОкончанияАктуализации();
	ПараметрыРасчета.Контрагент         = Контрагент;
	ПараметрыРасчета.ДоговорКонтрагента = ДоговорКонтрагента;
	ПараметрыРасчета.АдресХранилищаСОшибками = АдресХранилищаСОшибками;
	
	РезультатЗадания = УчетВзаиморасчетовОтложенноеПроведение.ЗапуститьОтложенныеРасчетыВФоне(
		УникальныйИдентификатор, 
		ПараметрыРасчета);

	АдресХранилищаОтложенныеРасчеты = РезультатЗадания.АдресРезультата;
	ИдентификаторЗаданияОтложенныеРасчеты = РезультатЗадания.ИдентификаторЗадания;
	
	Если РезультатЗадания.Статус <> "Выполняется" Тогда
		ЗаданиеВыполнено = Истина;
		ЗагрузитьДанныеПослеОтложенногоРасчета();
	Иначе
		УстановитьВидимостьЭлементовОжиданияОтложенныеРасчеты();
	КонецЕсли;
	
	Возврат ЗаданиеВыполнено;

КонецФункции

&НаКлиенте
Процедура ОжидатьВыполнениеОтложенныхРасчетов()

	ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеОтложенныхРасчетов", 1, Истина);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеОтложенныхРасчетов()

	Попытка
		Если ЗначениеЗаполнено(ИдентификаторЗаданияОтложенныеРасчеты)
			И ЗаданиеВыполнено(ИдентификаторЗаданияОтложенныеРасчеты) Тогда 

			ЗагрузитьДанныеПослеОтложенногоРасчета();
			ПоказатьРезультатОтложенногоРасчета();
		
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеОтложенныхРасчетов", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ИдентификаторЗаданияОтложенныеРасчеты = Неопределено;
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьРезультатОтложенногоРасчета()

	Если ЭтоАдресВременногоХранилища(АдресХранилищаСОшибками) Тогда
		ОбщегоНазначенияБПКлиент.ОткрытьФормуОшибокПерепроведения(ЭтотОбъект, АдресХранилищаСОшибками);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеПослеОтложенногоРасчета()
	
	УчетВзаиморасчетовОтложенноеПроведение.ОбработатьРезультатВыполненияАктуализацияРасчетов(ЭтотОбъект);
	
	// Обновляем данные на форме.
	СформироватьСервер();
	
КонецПроцедуры

#КонецОбласти
