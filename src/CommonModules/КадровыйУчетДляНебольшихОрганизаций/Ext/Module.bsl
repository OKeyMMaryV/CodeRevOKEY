﻿////////////////////////////////////////////////////////////////////////////////
// Кадровый учет для небольших организаций
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	
	Списки.Вставить(Метаданные.Документы.КадровыйПеревод, Истина);
	Списки.Вставить(Метаданные.Справочники.КадровыйПереводПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Документы.ПриемНаРаботу, Истина);
	Списки.Вставить(Метаданные.Справочники.ПриемНаРаботуПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Документы.Увольнение, Истина);
	Списки.Вставить(Метаданные.Справочники.УвольнениеПрисоединенныеФайлы, Истина);
	
КонецПроцедуры

#КонецОбласти

Функция СведенияОСреднемЗаработкеДляСправкиПоБезработице(КадровыеДанныеСотрудников) Экспорт
	
	СведенияОСреднемЗаработке = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("КадровыеДанныеСотрудников", КадровыеДанныеСотрудников);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КадровыеДанныеСотрудников.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	КадровыеДанныеСотрудников.Сотрудник,
		|	КадровыеДанныеСотрудников.ДатаПриема,
		|	КадровыеДанныеСотрудников.ДатаУвольнения,
		|	КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(КадровыеДанныеСотрудников.ДатаУвольнения, МЕСЯЦ, -1), МЕСЯЦ) КАК ОкончаниеПериода
		|ПОМЕСТИТЬ ВТПериодыРаботыФизическихЛицПредварительно
		|ИЗ
		|	&КадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПериодыРаботы.ГоловнаяОрганизация,
		|	ПериодыРаботы.Сотрудник,
		|	ПериодыРаботы.ДатаПриема,
		|	ПериодыРаботы.ДатаУвольнения,
		|	НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПериодыРаботы.ОкончаниеПериода, МЕСЯЦ, -2), МЕСЯЦ) КАК НачалоТрехмесячногоПериода,
		|	ВЫБОР
		|		КОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПериодыРаботы.ОкончаниеПериода, МЕСЯЦ, -2), МЕСЯЦ) > ПериодыРаботы.ДатаПриема
		|			ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПериодыРаботы.ОкончаниеПериода, МЕСЯЦ, -2), МЕСЯЦ)
		|		ИНАЧЕ ПериодыРаботы.ДатаПриема
		|	КОНЕЦ КАК НачалоПериода,
		|	ПериодыРаботы.ОкончаниеПериода
		|ПОМЕСТИТЬ ВТПериодыРаботыФизическихЛиц
		|ИЗ
		|	ВТПериодыРаботыФизическихЛицПредварительно КАК ПериодыРаботы";
	
	Запрос.Выполнить();
	
	РасчетЗарплатыДляНебольшихОрганизаций.СоздатьВТНачисленияЗарплаты(Запрос.МенеджерВременныхТаблиц);
	РасчетЗарплатыДляНебольшихОрганизаций.СоздатьВТПериодыОтсутствий(Запрос.МенеджерВременныхТаблиц);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация,
		|	ПериодыРаботыФизическихЛиц.Сотрудник,
		|	ПериодыРаботыФизическихЛиц.НачалоТрехмесячногоПериода,
		|	ПериодыРаботыФизическихЛиц.НачалоПериода,
		|	ПериодыРаботыФизическихЛиц.ОкончаниеПериода,
		|	СУММА(НачисленияЗарплаты.Сумма) КАК Сумма
		|ПОМЕСТИТЬ ВТПериодыРаботыФизическихЛицССуммой
		|ИЗ
		|	ВТПериодыРаботыФизическихЛиц КАК ПериодыРаботыФизическихЛиц
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНачисленияЗарплаты КАК НачисленияЗарплаты
		|		ПО ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация = НачисленияЗарплаты.ГоловнаяОрганизация
		|			И ПериодыРаботыФизическихЛиц.Сотрудник = НачисленияЗарплаты.Сотрудник
		|
		|СГРУППИРОВАТЬ ПО
		|	ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация,
		|	ПериодыРаботыФизическихЛиц.Сотрудник,
		|	ПериодыРаботыФизическихЛиц.НачалоТрехмесячногоПериода,
		|	ПериодыРаботыФизическихЛиц.НачалоПериода,
		|	ПериодыРаботыФизическихЛиц.ОкончаниеПериода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация,
		|	ПериодыРаботыФизическихЛиц.Сотрудник,
		|	ПериодыРаботыФизическихЛиц.НачалоТрехмесячногоПериода,
		|	ПериодыРаботыФизическихЛиц.ОкончаниеПериода,
		|	ПериодыРаботыФизическихЛиц.Сумма,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеПроизводственногоКалендаря.Дата) - КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеПроизводственногоКалендаряОтсутствий.Дата) КАК ОтработаноДней
		|ПОМЕСТИТЬ ВТПериодыРаботыФизическихЛицССуммойИКоличествомОтработанныхДней
		|ИЗ
		|	ВТПериодыРаботыФизическихЛицССуммой КАК ПериодыРаботыФизическихЛиц
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНачисленияЗарплаты КАК НачисленияЗарплаты
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
		|			ПО НачисленияЗарплаты.ДатаНачала <= ДанныеПроизводственногоКалендаря.Дата
		|				И НачисленияЗарплаты.ДатаОкончания >= ДанныеПроизводственногоКалендаря.Дата
		|				И (ДанныеПроизводственногоКалендаря.ВидДня В (ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий), ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный)))
		|		ПО ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация = НачисленияЗарплаты.ГоловнаяОрганизация
		|			И ПериодыРаботыФизическихЛиц.Сотрудник = НачисленияЗарплаты.Сотрудник
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПериодыОтсутствий КАК ПериодыОтсутствий
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаряОтсутствий
		|			ПО ПериодыОтсутствий.ДатаНачала <= ДанныеПроизводственногоКалендаряОтсутствий.Дата
		|				И ПериодыОтсутствий.ДатаОкончания >= ДанныеПроизводственногоКалендаряОтсутствий.Дата
		|				И (ДанныеПроизводственногоКалендаряОтсутствий.ВидДня В (ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий), ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный)))
		|		ПО ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация = ПериодыОтсутствий.ГоловнаяОрганизация
		|			И ПериодыРаботыФизическихЛиц.Сотрудник = ПериодыОтсутствий.Сотрудник
		|
		|СГРУППИРОВАТЬ ПО
		|	ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация,
		|	ПериодыРаботыФизическихЛиц.Сотрудник,
		|	ПериодыРаботыФизическихЛиц.НачалоТрехмесячногоПериода,
		|	ПериодыРаботыФизическихЛиц.ОкончаниеПериода,
		|	ПериодыРаботыФизическихЛиц.Сумма
		|
		|ИМЕЮЩИЕ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеПроизводственногоКалендаря.Дата) - КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеПроизводственногоКалендаряОтсутствий.Дата) > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация,
		|	ПериодыРаботыФизическихЛиц.Сотрудник,
		|	ПериодыРаботыФизическихЛиц.Сумма,
		|	ПериодыРаботыФизическихЛиц.ОтработаноДней,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеПроизводственногоКалендаряЗаТриМесяца.Дата) КАК РабочихДнейВТрехМесяцах
		|ИЗ
		|	ВТПериодыРаботыФизическихЛицССуммойИКоличествомОтработанныхДней КАК ПериодыРаботыФизическихЛиц
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаряЗаТриМесяца
		|		ПО ПериодыРаботыФизическихЛиц.НачалоТрехмесячногоПериода <= ДанныеПроизводственногоКалендаряЗаТриМесяца.Дата
		|			И ПериодыРаботыФизическихЛиц.ОкончаниеПериода >= ДанныеПроизводственногоКалендаряЗаТриМесяца.Дата
		|			И (ДанныеПроизводственногоКалендаряЗаТриМесяца.ВидДня В (ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий), ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный)))
		|
		|СГРУППИРОВАТЬ ПО
		|	ПериодыРаботыФизическихЛиц.ГоловнаяОрганизация,
		|	ПериодыРаботыФизическихЛиц.Сотрудник,
		|	ПериодыРаботыФизическихЛиц.Сумма,
		|	ПериодыРаботыФизическихЛиц.ОтработаноДней";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("ГоловнаяОрганизация", Выборка.ГоловнаяОрганизация);
		СтруктураПоиска.Вставить("Сотрудник", Выборка.Сотрудник);
		
		СтрокиСотрудников = КадровыеДанныеСотрудников.НайтиСтроки(СтруктураПоиска);
		Если СтрокиСотрудников.Количество() > 0 Тогда
			
			СреднедневнойЗаработок = Выборка.Сумма / Выборка.ОтработаноДней;
			СреднийЗаработок = СреднедневнойЗаработок * Выборка.РабочихДнейВТрехМесяцах / 3;
			
			Для Каждого СтрокаСотрудника Из СтрокиСотрудников Цикл
				СведенияОСреднемЗаработке.Вставить(СтрокаСотрудника.Сотрудник, Окр(СреднийЗаработок, 2, РежимОкругления.Окр15как20));
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
		
	Возврат СведенияОСреднемЗаработке;
	
КонецФункции

Функция СведенияОПериодахНеРаботыДляСправкиПоБезработице(КадровыеДанныеСотрудников) Экспорт
	
	СведенияОПериодахНеРаботы = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("КадровыеДанныеСотрудников", КадровыеДанныеСотрудников);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КадровыеДанныеСотрудников.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	КадровыеДанныеСотрудников.Сотрудник,
		|	ВЫБОР
		|		КОГДА ДОБАВИТЬКДАТЕ(КадровыеДанныеСотрудников.ДатаУвольнения, ГОД, -1) > КадровыеДанныеСотрудников.ДатаПриема
		|			ТОГДА ДОБАВИТЬКДАТЕ(КадровыеДанныеСотрудников.ДатаУвольнения, ГОД, -1)
		|		ИНАЧЕ КадровыеДанныеСотрудников.ДатаПриема
		|	КОНЕЦ КАК НачалоПериода,
		|	КадровыеДанныеСотрудников.ДатаУвольнения КАК ОкончаниеПериода
		|ПОМЕСТИТЬ ВТПериодыРаботыФизическихЛиц
		|ИЗ
		|	&КадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников";
	
	Запрос.Выполнить();
	
	РасчетЗарплатыДляНебольшихОрганизаций.СоздатьВТПериодыОтсутствий(Запрос.МенеджерВременныхТаблиц);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПериодыОтсутствий.Сотрудник КАК Сотрудник,
		|	МИНИМУМ(ПериодыОтсутствий.ДатаНачала) КАК ДатаНачала,
		|	МАКСИМУМ(ПериодыОтсутствий.ДатаОкончания) КАК ДатаОкончания,
		|	ПериодыОтсутствий.СсылкаНаДокумент КАК СсылкаНаДокумент,
		|	ПериодыОтсутствий.ПричинаНеРаботы КАК ПричинаНеРаботы
		|ИЗ
		|	ВТПериодыОтсутствий КАК ПериодыОтсутствий
		|
		|СГРУППИРОВАТЬ ПО
		|	ПериодыОтсутствий.Сотрудник,
		|	ПериодыОтсутствий.СсылкаНаДокумент,
		|	ПериодыОтсутствий.ПричинаНеРаботы
		|
		|УПОРЯДОЧИТЬ ПО
		|	Сотрудник,
		|	ДатаНачала";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Сотрудник") Цикл
		
		СтрокиСотрудников = КадровыеДанныеСотрудников.НайтиСтроки(Новый Структура("Сотрудник", Выборка.Сотрудник));
		ПериодыНеРаботы = Новый Массив;
		
		Пока Выборка.Следующий() Цикл
			
			ПериодНеРаботы = Новый Структура;
			ПериодНеРаботы.Вставить("НачалоПериода", Выборка.ДатаНачала);
			ПериодНеРаботы.Вставить("ОкончаниеПериода", Выборка.ДатаОкончания);
			Если ТипЗнч(Выборка.СсылкаНаДокумент) = Тип("ДокументСсылка.Отпуск") Тогда
				
				ПериодНеРаботы.Вставить("ПричинаОтсутствия",
					НСтр("ru='Период, когда заработная плата не выплачивалась'"));
				
			Иначе
				
				ПериодНеРаботы.Вставить("ПричинаОтсутствия",
					НСтр("ru='Временная нетрудоспособность, в том числе отпуск по беременности и родам'"));
				
				
			КонецЕсли;
			
			ПериодыНеРаботы.Добавить(ПериодНеРаботы);
			
		КонецЦикла;
		
		Если ПериодыНеРаботы.Количество() > 0 Тогда
			
			Для Каждого СтрокаДанныхСотрудника Из СтрокиСотрудников Цикл
				СведенияОПериодахНеРаботы.Вставить(СтрокаДанныхСотрудника.Сотрудник, ПериодыНеРаботы);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
		
	Возврат СведенияОПериодахНеРаботы;
	
КонецФункции

#КонецОбласти
