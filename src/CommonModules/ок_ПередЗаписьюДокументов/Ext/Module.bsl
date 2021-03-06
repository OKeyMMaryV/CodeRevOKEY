/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Общий модуль выполняет обработку события "ПередЗаписью" 
// Для объектов включенных в подписку "ок_ПередЗаписьюДокументов"
//
// Для расширения функциональности, необходимо:
// 1. Включить "ДокументОбъект" в подписку "ок_ПередЗаписьюДокументов"
// 2. В процедуре "ок_ПередЗаписьюДокументовПередЗаписью" добавить ветку условия с проверкой на тип источника
// 3. Создать область по шаблону "Документ_ИмяДокумента"
// 4. Создать процедуру внутри области по шаблону "ПередЗаписьюДокумента_ИмяДокумента"
// 5. Вызвать созданную процедуру из ветки условия в процедуре "ок_ПередЗаписьюДокументовПередЗаписью"
// 6. Необходимые служебные процедуры и функции размещать в области модуля "СлужебныеПроцедурыИФункции"
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

//Процедура вызываемая подпиской на событие "ок_ПередЗаписьюДокументов"
// Параметры:
// Источник - Документ, Тип - ДокументОбъект
// Отказ - Флаг отказа, Тип - Булево
// РежимЗаписи - РежимЗаписиДокумента, Тип - РежимЗаписи
// РежимПроведения - РежимПроведенияДокумента, Тип - РежимПроведения
Процедура ок_ПередЗаписьюДокументовПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если ТипЗнч(Источник) = Тип("ДокументОбъект.бит_ЗаявкаНаРасходованиеСредств") Тогда
		ПередЗаписьюДокумента_БитЗаявкаНаРасходованиеСредств(Источник, Отказ, РежимЗаписи, РежимПроведения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Документ_бит_ЗаявкаНаРасходованиеСредств

Процедура ПередЗаписьюДокумента_БитЗаявкаНаРасходованиеСредств(Источник, Отказ, РежимЗаписи, РежимПроведения)
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// ОКЕЙ Смирнов М.В. (СофтЛаб) Начало 2021-07-15 (#4147)
	ВыполнитьПроверкуБлокировкиКонтрагентаИДоговора(Источник, Отказ, РежимЗаписи, РежимПроведения);
	// ОКЕЙ Смирнов М.В. (СофтЛаб) Конец 2021-07-15 (#4147)
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// ОКЕЙ Смирнов М.В. (СофтЛаб) Начало 2021-07-15 (#4147)
Процедура ВыполнитьПроверкуБлокировкиКонтрагентаИДоговора(Источник, Отказ, РежимЗаписи, РежимПроведения)
	
	Если РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаОшибок = Новый ТаблицаЗначений;
	ТаблицаОшибок.Колонки.Добавить("ТекстОшибки", ОбщегоНазначения.ОписаниеТипаСтрока(100));
	ТаблицаОшибок.Колонки.Добавить("ПолеКлюча", ОбщегоНазначения.ОписаниеТипаСтрока(30));
	ТаблицаОшибок.Колонки.Добавить("ОшибкаВТЧ", Новый ОписаниеТипов("Булево"));
	
	// проверка контрагента
	Если ЗначениеЗаполнено(Источник.Контрагент) Тогда
		
		Результат = Справочники.Контрагенты.ПолучитьДанныеИсторииСтатусаКонтрагента(Источник.Контрагент, Источник.ДатаРасхода);
		
		Если Результат <> Неопределено 
			И (Результат.Статус = Перечисления.бит_СтатусыПоставщиковAX.БлокированыОплаты
				Или Результат.Статус = Перечисления.бит_СтатусыПоставщиковAX.БлокированоВсе) Тогда
			
			НоваяОшибка = ТаблицаОшибок.Добавить();
			НоваяОшибка.ТекстОшибки = НСтр("ru = 'Контрагент заблокирован к оплате'");
			НоваяОшибка.ПолеКлюча = "Контрагент";
			
		КонецЕсли;
		
	КонецЕсли;
	
	// проверка договора
	Если Источник.Распределение.Количество() > 1 Тогда
		
		Для каждого Строка Из Источник.Распределение Цикл
			
			Результат = Справочники.ДоговорыКонтрагентов.ПолучитьДанныеИсторииСтатусаДоговора(Строка.ДоговорКонтрагента, Источник.ДатаРасхода);
			
			Если Результат <> Неопределено 
				И (Результат.Статус = Перечисления.бит_ВидыСтадийДоговоров.Замечания
				Или Результат.Статус = Перечисления.бит_ВидыСтадийДоговоров.Закрыт) Тогда
				
				ПутьКПолюТабличнойЧасти = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Распределение", Строка.НомерСтроки, "ДоговорКонтрагента");
	
				НоваяОшибка = ТаблицаОшибок.Добавить();
				
				НоваяОшибка.ТекстОшибки = СтрШаблон(НСтр("ru = 'Договор в строке %1 заблокирован к оплате'"), Формат(Строка.НомерСтроки, "ЧГ=0"));
				НоваяОшибка.ПолеКлюча = ПутьКПолюТабличнойЧасти;
				НоваяОшибка.ОшибкаВТЧ = Истина;
				
			КонецЕсли;
			
		КонецЦикла;
		
	ИначеЕсли ЗначениеЗаполнено(Источник.ДоговорКонтрагента) Тогда
		
		Результат = Справочники.ДоговорыКонтрагентов.ПолучитьДанныеИсторииСтатусаДоговора(Источник.ДоговорКонтрагента, Источник.ДатаРасхода);
		
		Если Результат <> Неопределено 
			И (Результат.Статус = Перечисления.бит_ВидыСтадийДоговоров.Замечания
			Или Результат.Статус = Перечисления.бит_ВидыСтадийДоговоров.Закрыт) Тогда
			
			НоваяОшибка = ТаблицаОшибок.Добавить();
			НоваяОшибка.ТекстОшибки = НСтр("ru = 'Договор заблокирован к оплате'");
			НоваяОшибка.ПолеКлюча = "ДоговорКонтрагента";
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТаблицаОшибок.Количество() = 0 Тогда // Нет ошибок заполнения
		Возврат;
	КонецЕсли;
	
	Если Источник.ЭтоНовый()
		И (Источник.ок_СпособСоздания = 6 Или Источник.ок_СпособСоздания = 7) Тогда // в этом случае документ создается путем загрузки из аксапты
		
		МассивОшибок = ТаблицаОшибок.ВыгрузитьКолонку("ТекстОшибки");
		
		ТекстСообщения = СтрСоединить(МассивОшибок, Символы.ПС);
		
		Источник.Комментарий = СтрШаблон("ru = '%1 
                                          |%2'", Источник.Комментарий, ТекстСообщения);
		
		РежимЗаписи = РежимЗаписиДокумента.Запись;
		
		СсылкаНовогоОбъекта = Документы.бит_ЗаявкаНаРасходованиеСредств.ПолучитьСсылку();
		Источник.УстановитьСсылкуНового(СсылкаНовогоОбъекта);
		
		Ошибка = СБ_КазначействоПовтИсп.ПолучитьЗначениеКонстанты("СтатусЗаявки_Ошибка", Справочники.бит_СтатусыОбъектов.Заявка_Черновик);
		бит_БК_Общий.УстановитьСтатусЗаявки(СсылкаНовогоОбъекта, Ошибка);
		
	Иначе
		
		Для каждого СтрокаОшибка Из ТаблицаОшибок Цикл
			
			Если СтрокаОшибка.ОшибкаВТЧ Тогда
				ОбщегоНазначения.СообщитьПользователю(СтрокаОшибка.ТекстОшибки,, СтрокаОшибка.ПолеКлюча,, Отказ);
			Иначе
				ОбщегоНазначения.СообщитьПользователю(СтрокаОшибка.ТекстОшибки, Источник[СтрокаОшибка.ПолеКлюча],,, Отказ);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры
// ОКЕЙ Смирнов М.В. (СофтЛаб) Конец 2021-07-15 (#4147)

#КонецОбласти