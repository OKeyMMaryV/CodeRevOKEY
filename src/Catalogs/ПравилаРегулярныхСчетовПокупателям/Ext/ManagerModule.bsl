﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает правило по счету
//
// Параметры:
//  СчетПокупателю - ДокументСсылка.СчетНаОплатуПокупателю
//
// Возвращаемое значение:
//  СправочникСсылка.ПравилаРегулярныхСчетовПокупателям Или Неопределено, если правило не найдено
//
Функция ПравилоПоСчету(СчетПокупателю) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Шаблон", СчетПокупателю);
	Запрос.УстановитьПараметр("Организации", ОбщегоНазначенияБПВызовСервераПовтИсп.ОрганизацииДанныеКоторыхДоступныПользователю());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПравилаРегулярныхСчетовПокупателям.Ссылка КАК Правило
	|ИЗ
	|	Справочник.ПравилаРегулярныхСчетовПокупателям КАК ПравилаРегулярныхСчетовПокупателям
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РегулярныеСчетаПокупателям КАК РегулярныеСчетаПокупателям
	|		ПО (РегулярныеСчетаПокупателям.Правило = ПравилаРегулярныхСчетовПокупателям.Ссылка)
	|ГДЕ
	|	ПравилаРегулярныхСчетовПокупателям.Организация В(&Организации)
	|	И РегулярныеСчетаПокупателям.Шаблон = &Шаблон";
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Правило;
	Иначе
		Возврат Неопределено;
	КонецЕсли; 
	
КонецФункции 

// Возвращает дату следующего счета по правилу.
//
// Параметры:
//   Правило - СправочникСсылка.ПравилаРегулярныхСчетовПокупателям
//
// Возвращаемое значение:
//   ДатаСледующего
//
Функция ДатаСледующего(Правило) Экспорт
	
	ДатаСледующего = Следующий(Правило).ДатаСледующего;
	
	Возврат ДатаСледующего;
	
КонецФункции

// Возвращает реквизиты следующего счета по правилу.
//
// Параметры:
//   Правило - СправочникСсылка.ПравилаРегулярныхСчетовПокупателям
//
// Возвращаемое значение:
//  Структура
//   * Организация
//   * Контрагент
//   * Сумма
//   * Шаблон
//   * ДатаШаблона
//
Функция Следующий(Правило) Экспорт
	
	СтруктураСледующий = Новый Структура;
	
	СтруктураСледующий.Вставить("Организация",    Справочники.Организации.ПустаяСсылка());
	СтруктураСледующий.Вставить("Контрагент",     Справочники.Контрагенты.ПустаяСсылка());
	СтруктураСледующий.Вставить("Сумма",          0);
	СтруктураСледующий.Вставить("ДатаСледующего", Дата(1,1,1));
	СтруктураСледующий.Вставить("ДатаШаблона",    Дата(1,1,1));
	СтруктураСледующий.Вставить("Шаблон",         Документы.СчетНаОплатуПокупателю.ПустаяСсылка());
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Правило", Правило);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РегулярныеСчетаПокупателямСрезПоследних.Организация,
	|	РегулярныеСчетаПокупателямСрезПоследних.Период КАК ДатаСледующего,
	|	РегулярныеСчетаПокупателямСрезПоследних.Шаблон,
	|	СчетНаОплатуПокупателю.Дата КАК ДатаШаблона,
	|	СчетНаОплатуПокупателю.Контрагент,
	|	СчетНаОплатуПокупателю.СуммаДокумента КАК Сумма
	|ИЗ
	|	РегистрСведений.РегулярныеСчетаПокупателям.СрезПоследних(, Правило = &Правило) КАК РегулярныеСчетаПокупателямСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетНаОплатуПокупателю КАК СчетНаОплатуПокупателю
	|		ПО РегулярныеСчетаПокупателямСрезПоследних.Шаблон = СчетНаОплатуПокупателю.Ссылка
	|			И РегулярныеСчетаПокупателямСрезПоследних.Организация = СчетНаОплатуПокупателю.Организация";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда 
		
		ЗаполнитьЗначенияСвойств(СтруктураСледующий, Выборка);
		
	КонецЕсли;
	
	Возврат СтруктураСледующий;
	
КонецФункции

// Возвращает структуру, содержащую данные для формирования надписи в форме списка счетов.
//
// Возвращаемое значение:
//  Результат - Структура:
//   * КоличествоЗапланировано – Сколько счетов запланировано
//   * КоличествоПросрочено    – Сколько счетов просрочено
//   * ДатаСледующего          – На какую дату запланирован следующий счет
//   * ОсталосьДней            – Сколько дней осталось до следующего счета
//
Функция ДанныеДляНадписиЗапланировано() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("КоличествоЗапланировано", 0);
	Результат.Вставить("КоличествоПросрочено", 0);
	Результат.Вставить("ДатаСледующего");
	Результат.Вставить("ОсталосьДней");
	
	ТекущаяДата = НачалоДня(ТекущаяДатаСеанса());
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата);
	Запрос.УстановитьПараметр("Организации",
		ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(Ложь));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(1) КАК Запланировано,
	|	СУММА(ВЫБОР
	|			КОГДА РегулярныеСчетаПокупателямСрезПоследних.Период < &ТекущаяДата
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Просрочено,
	|	МИНИМУМ(РегулярныеСчетаПокупателямСрезПоследних.Период) КАК ДатаСледующего
	|ИЗ
	|	РегистрСведений.РегулярныеСчетаПокупателям.СрезПоследних(, Правило.Выполняется) КАК РегулярныеСчетаПокупателямСрезПоследних
	|ГДЕ
	|	РегулярныеСчетаПокупателямСрезПоследних.Организация В(&Организации)";
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() И ЗначениеЗаполнено(Выборка.Запланировано) Тогда
		
		Результат.КоличествоЗапланировано = Выборка.Запланировано;
		Результат.КоличествоПросрочено    = Выборка.Просрочено;
		
		Результат.ДатаСледующего = Выборка.ДатаСледующего;
		
		СекундВДне = 86400;
		
		Результат.ОсталосьДней = (Выборка.ДатаСледующего - ТекущаяДата)/СекундВДне;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Для переданных правил сдвигает дату следующего запланированного документа в следующий период.
//
// Параметры:
//   Правила - Массив - Массив правил.
//
Процедура ПропуститьПовторение(Правила) Экспорт
	
	Для Каждого Правило Из Правила Цикл
		
		СтруктураСледующий = Следующий(Правило);
		
		РегистрыСведений.РегулярныеСчетаПокупателям.УстановитьШаблон(Правило, СтруктураСледующий.Шаблон);
		
	КонецЦикла;
	
КонецПроцедуры

// Создает документы по переданным правилам.
//
// Параметры:
//   Правила - Массив - Массив правил.
//
// Возвращаемое значение:
//   СозданныеДокументы - Массив - Массив ссылок на счета покупателю.
//
Функция СоздатьДокументыПоПравилам(Правила) Экспорт
	
	СозданныеДокументы = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Правила", Правила);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РегулярныеСчетаПокупателямСрезПоследних.Шаблон,
	|	РегулярныеСчетаПокупателямСрезПоследних.Правило
	|ИЗ
	|	РегистрСведений.РегулярныеСчетаПокупателям.СрезПоследних(, Правило В (&Правила)) КАК РегулярныеСчетаПокупателямСрезПоследних";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТекущаяДата = НачалоДня(ТекущаяДатаСеанса());
	
	Пока Выборка.Следующий() Цикл
		
		НовыйДокумент = Выборка.Шаблон.Скопировать();
		
		НовыйДокумент.УстановитьНовыйНомер();
		
		НовыйДокумент.Записать();
		
		РегистрыСведений.РегулярныеСчетаПокупателям.УстановитьШаблон(Выборка.Правило, НовыйДокумент.Ссылка);
		
		СозданныеДокументы.Добавить(НовыйДокумент.Ссылка);
		
	КонецЦикла;
	
	Возврат СозданныеДокументы;
	
КонецФункции

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

#КонецЕсли
