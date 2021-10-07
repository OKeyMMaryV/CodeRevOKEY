﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

	#Область ОбработчикиСобытий

// Процедура - обработчик события "ОбработкаЗаполнения".
// 
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ПервоначальноеЗаполнениеДокумента();
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события "ПриКопировании".
// 
Процедура ПриКопировании(ОбъектКопирования)
	
	ПервоначальноеЗаполнениеДокумента(ОбъектКопирования);
	
КонецПроцедуры

// Процедура - обработчик события "ПередЗаписью".
// 
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
	
	// Подсчитаем и запишем сумму документа.
	СуммаДокумента = ГрафикНачислений.Итог("Сумма");
	
	Если Не Отказ Тогда
		
		// Выполним синхронизацию пометки на удаление объекта и дополнительных файлов.
		бит_ХранениеДополнительнойИнформации.СинхронизацияПометкиНаУдалениеУДополнительныхФайлов(ЭтотОбъект);
		
	КонецЕсли; // Если Не Отказ Тогда
	
КонецПроцедуры // ПередЗаписью()
	
Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	
		
КонецПроцедуры // ПриЗаписи()

// Процедура - обработчик события "ОбработкаПроведения".
// 
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	

	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = бит_ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// Проверка ручной корректировки.
	Если бит_ОбщегоНазначения.РучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка, Отказ, Заголовок, ЭтотОбъект, Ложь) Тогда
		Возврат
	КонецЕсли;
	
	СтруктураШапкиДокумента = бит_ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	СтруктураТаблиц 		= ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента);	
	
	// ПроверкаДанных(СтруктураШапкиДокумента, СтруктураТаблиц, Отказ, Заголовок);
	
	// Получим курсы валют, неоходимые для выполнения пересчетов.
	ВидыКурсов = Новый Структура("Упр,Регл,МУ,Документ,Взаиморасчеты");
	СтруктураКурсыВалют = бит_му_ОбщегоНазначения.ПолучитьСтруктуруКурсовВалют(ЭтотОбъект, СтруктураШапкиДокумента.Дата, ВидыКурсов);
	
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, СтруктураТаблиц, СтруктураКурсыВалют, Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события "ОбработкаУдаленияПроведения".
// 
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	бит_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Процедура обрабатывает изменение валюты документа.
// 
// Параметры:
//  Нет.
// 
Процедура ИзменениеВалютыМодуль() Экспорт

	СтруктураКурса = бит_КурсыВалют.ПолучитьКурсВалюты(ВалютаДокумента, Дата);
	
	КурсДокумента      = СтруктураКурса.Курс;
	КратностьДокумента = СтруктураКурса.Кратность;

КонецПроцедуры // ИзменениеВалютыМодуль()

// Функция возвращает коэффициент пересчета сумм из валюты международного учета в валюту документа.
// 
Функция ПолучитьКоэффициентВалют() Экспорт
	
	ВидыКурсов			= Новый Структура("Документ,Взаиморасчеты");
	СтруктураКурсыВалют = бит_му_ОбщегоНазначения.ПолучитьСтруктуруКурсовВалют(ЭтотОбъект, Дата, ВидыКурсов);
	
	КурсыВз  	= СтруктураКурсыВалют.Взаиморасчеты;
	КурсыДок 	= СтруктураКурсыВалют.Документ;

	Коэффициент = бит_КурсыВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(1, КурсыВз.Валюта, 		КурсыДок.Валюта,
																	 КурсыВз.Курс, 		КурсыДок.Курс,
																	 КурсыВз.Кратность, 	КурсыДок.Кратность);
																	 
	Возврат Коэффициент;
	
КонецФункции

// Получает способ расчета ЭСП в зависимости от вида операции и организации.
// 
// Возвращаемое значение:
//  СпособРасчетаЭСП - ПеречислениеСсылка.бит_му_СпособыРасчетаЭСП.
// 
Функция ОпределитьСпособРасчетаЭСП() Экспорт
	
	СпособРасчетаЭСП = Перечисления.бит_му_СпособыРасчетаЭСП.ПоМесяцам;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ЭтотОбъект.ДоговорКонтрагента);
	Запрос.УстановитьПараметр("Параметр", ПланыВидовХарактеристик.бит_му_ВидыПараметровФинИнструментов.СпособРасчетаЭСП);
	Запрос.Текст = "ВЫБРАТЬ
				   |	бит_му_ПараметрыФинИнструментовСрезПоследних.ЗначениеПараметра
				   |ИЗ
				   |	РегистрСведений.бит_му_ПараметрыФинИнструментов.СрезПоследних КАК бит_му_ПараметрыФинИнструментовСрезПоследних
				   |ГДЕ
				   |	бит_му_ПараметрыФинИнструментовСрезПоследних.ДоговорКонтрагента = &ДоговорКонтрагента
				   |	И бит_му_ПараметрыФинИнструментовСрезПоследних.Параметр = &Параметр";
				   
				   
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
	
	  СпособРасчетаЭСП = Выборка.ЗначениеПараметра;	
	
	КонецЕсли; 
	
	Возврат СпособРасчетаЭСП;
	
КонецФункции // ОпределитьСпособРасчетаЭСП()

// Функция возвращает финансовый график.
// 
// Параметры:
//  СтруктураКурсыВалют	- Структура.
//  ДатаКорректировок   - Дата.
//  ДобавлятьНулевоуюСтроку - Булево.
// 
// Возвращаемое значение:
//  Результат - ТаблицаЗначений.
// 
Функция ПолучитьФинансовыйГрафик(СтруктураКурсыВалют, ДатаКорректировок,ДобавлятьНулевуюСтроку = Ложь) Экспорт
	
	ТаблицаДанных = ГрафикНачислений.Выгрузить();
	ТаблицаДанных.Сортировать("Период");
	
	// Оставим в таблице значений строки, начиная с первой скорректированной.
	МассивДляУдаления = Новый Массив;
	Для каждого ТекСтр Из ТаблицаДанных Цикл
		Если ТекСтр.Период < НачалоМесяца(ДатаКорректировок) Тогда
			МассивДляУдаления.Добавить(ТекСтр);
		КонецЕсли; 
	КонецЦикла;
	
	Для каждого ТекСтр Из МассивДляУдаления Цикл
		ТаблицаДанных.Удалить(ТекСтр);
	КонецЦикла;
	
	КурсыРегл 			= СтруктураКурсыВалют["Регл"];
	КурсыВзаиморасчеты 	= СтруктураКурсыВалют["Взаиморасчеты"];
	
	// Добавим колонки для сумм в валютах регл. учета и взаиморасчетов.
	ТаблицаДанных.Колонки.Добавить("СуммаПлатежаРегл", 			Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("СуммаПлатежаВзаиморасчеты",	Новый ОписаниеТипов("Число"));
	
	// Пересчитаем суммы в таблице значений
	Для каждого ТекСтр Из ТаблицаДанных Цикл
		ТекСтр.СуммаПлатежаРегл = бит_КурсыВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(ТекСтр.Сумма
																					 ,ВалютаДокумента
																					 ,КурсыРегл.Валюта
																					 ,КурсДокумента
																					 ,КурсыРегл.Курс
																					 ,КратностьДокумента
																					 ,КурсыРегл.Кратность);

		ТекСтр.СуммаПлатежаВзаиморасчеты = бит_КурсыВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(ТекСтр.Сумма
																					 ,ВалютаДокумента
																					 ,КурсыВзаиморасчеты.Валюта
																					 ,КурсДокумента
																					 ,КурсыВзаиморасчеты.Курс
																					 ,КратностьДокумента
																					 ,КурсыВзаиморасчеты.Кратность);
	КонецЦикла;
	
	// Изменение кода. Начало. 11.10.2010{{
	// Если ДобавлятьНулевуюСтроку И  ТаблицаДанных.Количество() >0 Тогда
	Если  ТаблицаДанных.Количество() >0 Тогда		
		
		Если  ДобавлятьНулевуюСтроку Тогда
			ДатаНач = НачалоМесяца(ДатаКорректировок)-1;
		Иначе	
			ДатаНач = КонецМесяца(ДатаКорректировок);
		КонецЕсли; 
		
		ПерваяСтрока = ТаблицаДанных[0];
		Если КонецМесяца(ПерваяСтрока.Период) <> КонецМесяца(ДатаНач)  Тогда
			
			НоваяСтрока = ТаблицаДанных.Вставить(0);
			НоваяСтрока.Период                    = ДатаНач;
			НоваяСтрока.СуммаПлатежаРегл          = 0;
			НоваяСтрока.СуммаПлатежаВзаиморасчеты = 0;
			
		КонецЕсли;	
		
		
		// Удалим нулевые строки с конца, если таковые есть.
		КоличествоСтрок = ТаблицаДанных.Количество();
		Для инд = 1 По КоличествоСтрок Цикл
		
			ИндСтр = КоличествоСтрок - инд;
			ТекСтрока = ТаблицаДанных[ИндСтр];
			Если ТекСтрока.СуммаПлатежаРегл = 0 И ТекСтрока.СуммаПлатежаВзаиморасчеты = 0 Тогда
			
				ТаблицаДанных.Удалить(ИндСтр);
				
			Иначе
				
				Прервать;
			
			КонецЕсли; 
		
		КонецЦикла; 
		
		
	КонецЕсли; 
	// Изменение кода. Конец. 11.10.2010}}
	
	Возврат ТаблицаДанных; 
	
КонецФункции // ПолучитьФинансовыйГрафик()

// Функция готовит таблицы документа для проведения.
// 
// Параметры:
//  СтруктураШапкиДокумента - Структура.
// 
// Возвращаемое значение:
//  СтруктураТаблиц - Структура.
// 
Функция ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента)  Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТабЧасть.НомерСтроки,
	               |	ТабЧасть.Период,
	               |	ТабЧасть.СуммаСтарый,
	               |	ТабЧасть.Сумма,
	               |	ТабЧасть.ДобавленоВручную
	               |ИЗ
	               |	Документ.бит_му_КорректировкаГрафиковФинансовыхНачислений.ГрафикНачислений КАК ТабЧасть
	               |ГДЕ
	               |	ТабЧасть.Ссылка = &Ссылка";
				   
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаПоГрафикНачислений = РезультатЗапроса.Выгрузить();
	
	СтруктураТаблиц = Новый Структура;
	СтруктураТаблиц.Вставить("ГрафикНачислений", ТаблицаПоГрафикНачислений);
	
	Возврат СтруктураТаблиц;
	                              
КонецФункции // ПодготовитьТаблицыДокумента()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет первоначальное заполнение созданного/скопированного документа.
// 
// Параметры:
//  ПараметрОбъектКопирования - ДокументОбъект.
// 
Процедура ПервоначальноеЗаполнениеДокумента(ПараметрОбъектКопирования = Неопределено)
	
	бит_ОбщегоНазначения.ЗаполнитьШапкуДокумента(ЭтотОбъект
												,бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь")
												,ПараметрОбъектКопирования);
	
	// Документ не скопирован.
	Если ПараметрОбъектКопирования = Неопределено Тогда
		
		Если Не ЗначениеЗаполнено(ВалютаДокумента) Тогда
			
			// Заполним валюту документа валютой международного учета.
			ВалютаДокумента = бит_му_ОбщегоНазначения.ПолучитьВалютуМеждународногоУчета(Организация,, Ложь);
			
		КонецЕсли; 
		
	КонецЕсли;
	
	ИзменениеВалютыМодуль();
	
	ДатаНачалаКорректировок = КонецМесяца(ТекущаяДата());
		
КонецПроцедуры // ПервоначальноеЗаполнениеДокумента()

// процедура проверяет дату начала корректировок.
// 
// Параметры:
//  ДатаНач - Дата.
// 	Отказ 	- Булево.
// 
Процедура ПроверитьДатуНачалаКорректировок(ДатаНач, Отказ)

	// Пользователь не может редактировать суммы,
	// если после даты были события начисления процентов или реклассификации
	// или в этом же месяце.
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", 			НачалоМесяца(ДатаНач));
	Запрос.УстановитьПараметр("Организация", 	Организация);
	
	ВидыИсточниковЗадолженности = Перечисления.бит_му_ВидыИсточниковЗадолженности;
	
	Если ВидИсточникаЗадолженности = ВидыИсточниковЗадолженности.ОсновныеСредства Тогда
		Запрос.Текст = "ВЫБРАТЬ
		               |	бит_му_СобытияОССрезПоследних.Регистратор
		               |ИЗ
		               |	РегистрСведений.бит_му_СобытияОС.СрезПервых(
		               |			&Дата,
		               |			Организация = &Организация
		               |				И ОсновноеСредство = &ОсновноеСредство
		               |				И Событие В (&Событие)) КАК бит_му_СобытияОССрезПоследних";
		
		МассивСобытий = Новый Массив;
		МассивСобытий.Добавить(Перечисления.бит_му_СобытияОС.НачислениеПроцентов);
		МассивСобытий.Добавить(Перечисления.бит_му_СобытияОС.РеклассификацияЗадолженности);
		
		Запрос.УстановитьПараметр("ОсновноеСредство", 	Объект);
		Запрос.УстановитьПараметр("Событие",			МассивСобытий);
		
	ИначеЕсли ВидИсточникаЗадолженности = ВидыИсточниковЗадолженности.КредитыЗаймы Тогда
		Запрос.Текст = "ВЫБРАТЬ
		               |	бит_му_СобытияФинИнструментовСрезПоследних.Регистратор
		               |ИЗ
		               |	РегистрСведений.бит_му_СобытияФинИнструментов.СрезПервых(
		               |			&Дата,
		               |			ДоговорКонтрагента = &ДоговорКонтрагента
		               |				И Организация = &Организация
		               |				И Событие В (&Событие)) КАК бит_му_СобытияФинИнструментовСрезПоследних";
					   
		МассивСобытий = Новый Массив;
		МассивСобытий.Добавить(Перечисления.бит_му_СобытияФинИнструментов.НачислениеПроцентов);
		МассивСобытий.Добавить(Перечисления.бит_му_СобытияФинИнструментов.РеклассификацияЗадолженности);
		
		Запрос.УстановитьПараметр("ДоговорКонтрагента", Объект);
		Запрос.УстановитьПараметр("Событие",			МассивСобытий);
	ИначеЕсли ВидИсточникаЗадолженности = ВидыИсточниковЗадолженности.ДебиторскаяЗадолженность Тогда
		Запрос.Текст = "ВЫБРАТЬ
		               |	бит_му_СобытияФинИнструментовСрезПоследних.Регистратор
		               |ИЗ
		               |	РегистрСведений.бит_му_СобытияФинИнструментов.СрезПервых(
		               |			&Дата,
		               |			ДоговорКонтрагента = &ДоговорКонтрагента
		               |				И Организация = &Организация
		               |				И Событие В (&Событие)) КАК бит_му_СобытияФинИнструментовСрезПоследних";
					   
		МассивСобытий = Новый Массив;
		МассивСобытий.Добавить(Перечисления.бит_му_СобытияФинИнструментов.НачислениеПроцентов);
		МассивСобытий.Добавить(Перечисления.бит_му_СобытияФинИнструментов.РеклассификацияЗадолженности);
		
		Запрос.УстановитьПараметр("ДоговорКонтрагента", Объект);
		Запрос.УстановитьПараметр("Событие",			МассивСобытий);
	Иначе
		Запрос.Текст = "ВЫБРАТЬ
		               |	бит_му_СобытияФинИнструментовСрезПоследних.Регистратор
		               |ИЗ
		               |	РегистрСведений.бит_му_СобытияФинИнструментов.СрезПервых(
		               |			&Дата,
		               |			ДоговорКонтрагента = &ДоговорКонтрагента
		               |				И Организация = &Организация
		               |				И Событие В (&Событие)) КАК бит_му_СобытияФинИнструментовСрезПоследних";
					   
		МассивСобытий = Новый Массив;
		МассивСобытий.Добавить(Перечисления.бит_му_СобытияФинИнструментов.НачислениеПроцентов);
		МассивСобытий.Добавить(Перечисления.бит_му_СобытияФинИнструментов.РеклассификацияЗадолженности);
		
		Запрос.УстановитьПараметр("ДоговорКонтрагента", Объект);
		Запрос.УстановитьПараметр("Событие",			МассивСобытий);
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		СтрокаОшибок = НСтр("ru = 'Невозможно корректировать график начислений на дату %1%, т.к. существуют документы в более поздних периодах:'");
		СтрокаОшибок = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(СтрокаОшибок, Формат(ДатаНач, "ДФ=dd.MM.yyyy"));
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(СтрокаОшибок, ЭтотОбъект, , Отказ);
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(Строка(Выборка.Регистратор), ЭтотОбъект, , Отказ);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьДатуНачалаКорректировок(()

// Процедура формирует сторно-движения документа.
// 
// Параметры:
//  ТабГрафикНачислений - Таблица значений.
// 
Процедура СформироватьДвиженияСторно(ТабГрафикНачислений)

	НаборЗаписей = Движения.бит_му_ФинансовыеНачисления;
	
	Для каждого ТекСтр Из ТабГрафикНачислений Цикл
		
		ТекСтр.СуммаРегл										= - ТекСтр.СуммаРегл;
		ТекСтр.СуммаВзаиморасчеты								= - ТекСтр.СуммаВзаиморасчеты;
		ТекСтр.ПогашеннаяСуммаФинансовыхПроцентовРегл			= - ТекСтр.ПогашеннаяСуммаФинансовыхПроцентовРегл;
		ТекСтр.ПогашеннаяСуммаФинансовыхПроцентовВзаиморасчеты	= - ТекСтр.ПогашеннаяСуммаФинансовыхПроцентовВзаиморасчеты;
		ТекСтр.НачисленнаяСуммаФинансовыхПроцентовРегл			= - ТекСтр.НачисленнаяСуммаФинансовыхПроцентовРегл;
		ТекСтр.НачисленнаяСуммаФинансовыхПроцентовВзаиморасчеты	= - ТекСтр.НачисленнаяСуммаФинансовыхПроцентовВзаиморасчеты;
		ТекСтр.СуммаПлатежаРегл									= - ТекСтр.СуммаПлатежаРегл;
		ТекСтр.СуммаПлатежаВзаиморасчеты						= - ТекСтр.СуммаПлатежаВзаиморасчеты;
		
	КонецЦикла;
	
	// Запишем сторно-движения в регистр
	НаборЗаписей.мТаблицаДвижений = ТабГрафикНачислений;
	НаборЗаписей.ДобавитьДвижение();

КонецПроцедуры // СформироватьДвиженияСторно() 

// Функция возвращает график начислений.
// 
// Параметры:
//  ДатаНач 	- Дата.
// 
// Возвращаемое значение:
//  Результат 	- Таблица значений.
// 
Функция ПолучитьГрафикНачислений(ДатаНач)

	ТекстЗапроса = "ВЫБРАТЬ
	               |	бит_му_ФинансовыеНачисленияОбороты.Период КАК Период,
	               |	бит_му_ФинансовыеНачисленияОбороты.РасходДоход,
	               |	бит_му_ФинансовыеНачисленияОбороты.ВидСтавки,
	               |	бит_му_ФинансовыеНачисленияОбороты.ВидИсточникаЗадолженности,
	               |	бит_му_ФинансовыеНачисленияОбороты.Организация,
	               |	бит_му_ФинансовыеНачисленияОбороты.Контрагент,
	               |	бит_му_ФинансовыеНачисленияОбороты.ДоговорКонтрагента,
	               |	бит_му_ФинансовыеНачисленияОбороты.Объект,
	               |	бит_му_ФинансовыеНачисленияОбороты.СуммаРеглОборот КАК СуммаРегл,
	               |	бит_му_ФинансовыеНачисленияОбороты.СуммаВзаиморасчетыОборот КАК СуммаВзаиморасчеты,
	               |	бит_му_ФинансовыеНачисленияОбороты.ПогашеннаяСуммаФинансовыхПроцентовРеглОборот КАК ПогашеннаяСуммаФинансовыхПроцентовРегл,
	               |	бит_му_ФинансовыеНачисленияОбороты.ПогашеннаяСуммаФинансовыхПроцентовВзаиморасчетыОборот КАК ПогашеннаяСуммаФинансовыхПроцентовВзаиморасчеты,
	               |	бит_му_ФинансовыеНачисленияОбороты.НачисленнаяСуммаФинансовыхПроцентовРеглОборот КАК НачисленнаяСуммаФинансовыхПроцентовРегл,
	               |	бит_му_ФинансовыеНачисленияОбороты.НачисленнаяСуммаФинансовыхПроцентовВзаиморасчетыОборот КАК НачисленнаяСуммаФинансовыхПроцентовВзаиморасчеты,
	               |	бит_му_ФинансовыеНачисленияОбороты.СуммаПлатежаРеглОборот КАК СуммаПлатежаРегл,
	               |	бит_му_ФинансовыеНачисленияОбороты.СуммаПлатежаВзаиморасчетыОборот КАК СуммаПлатежаВзаиморасчеты
	               |ИЗ
	               |	РегистрНакопления.бит_му_ФинансовыеНачисления.Обороты(
	               |			&ДатаНач,
	               |			,
	               |			Запись,
	               |			Организация = &Организация
	               |				И Объект = &Объект
	               |				И Контрагент = &Контрагент
	               |				И ДоговорКонтрагента = &ДоговорКонтрагента
	               |				И ВидИсточникаЗадолженности = &ВидИсточникаЗадолженности) КАК бит_му_ФинансовыеНачисленияОбороты
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Период";
				   
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("ДатаНач",					ДатаНач);
	Запрос.УстановитьПараметр("Организация", 				Организация);
	Запрос.УстановитьПараметр("Контрагент",					Контрагент);
	Запрос.УстановитьПараметр("ДоговорКонтрагента", 		ДоговорКонтрагента);
	Запрос.УстановитьПараметр("Объект",		 				Объект);
	Запрос.УстановитьПараметр("ВидИсточникаЗадолженности", 	ВидИсточникаЗадолженности);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции // ПолучитьГрафикНачислений()

// Функция получает данные для корректировки периода между двумя графиками.
// 
// Параметры:
//  ПериодКоррект - Период.
//  ВидСтавки     - ПеречислениеСсылка.бит_му_ВидыСтавокФинансовыхПроцентов.
//  СтруктураКурсыВалют - Структура.
//  СтрПлатежи          - Структура.
// 
// Возвращаемое значение:
//  СтрРез - Структура.
// 
Функция ПолучитьДанныеДляКорректировки(ПериодКоррект, ВидСтавки, СтруктураКурсыВалют, СтрПлатежи)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
	Запрос.УстановитьПараметр("Контрагент"        , Контрагент);
	Запрос.УстановитьПараметр("Объект"            , Объект);
	Запрос.УстановитьПараметр("Организация"       , Организация);
	Запрос.УстановитьПараметр("ВидИсточникаЗадолженности", ВидИсточникаЗадолженности);
	Запрос.УстановитьПараметр("ВидСтавки"  , ВидСтавки);
	Запрос.УстановитьПараметр("Поступление", Перечисления.бит_РасходДоход.Поступление);
	Запрос.УстановитьПараметр("Расходование",Перечисления.бит_РасходДоход.Расходование);
	
	// Окончание периода без изменений
	КонецПериодаФикс = КонецМесяца(ДобавитьМесяц(ПериодКоррект,-1));
	Запрос.УстановитьПараметр("КонецПериодаФикс", КонецПериодаФикс);
	
	// Корректируемый период
	НачалоПериодаКоррект = НачалоМесяца(ПериодКоррект);
	КонецПериодаКоррект  = КонецМесяца(ПериодКоррект);
	Запрос.УстановитьПараметр("НачалоПериодаКоррект", НачалоПериодаКоррект);
	Запрос.УстановитьПараметр("КонецПериодаКоррект", КонецПериодаКоррект);
	
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	СУММА(ФинНачисленияОб.ПогашеннаяСуммаФинансовыхПроцентовРеглОборот) КАК ПогашеннаяСуммаФинансовыхПроцентовРегл,
	               |	СУММА(ФинНачисленияОб.ПогашеннаяСуммаФинансовыхПроцентовВзаиморасчетыОборот) КАК ПогашеннаяСуммаФинансовыхПроцентовВзаиморасчеты
	               |ИЗ
	               |	РегистрНакопления.бит_му_ФинансовыеНачисления.Обороты(
	               |			&НачалоПериодаКоррект,
	               |			&КонецПериодаКоррект,
	               |			Период,
	               |			ДоговорКонтрагента = &ДоговорКонтрагента
	               |				И Контрагент = &Контрагент
	               |				И Объект = &Объект
	               |				И Организация = &Организация
	               |				И ВидСтавки = &ВидСтавки
	               |				И ВидИсточникаЗадолженности = &ВидИсточникаЗадолженности) КАК ФинНачисленияОб
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СУММА(ВЫБОР
	               |			КОГДА ФинНачисленияОб.РасходДоход = &Поступление
	               |				ТОГДА ФинНачисленияОб.СуммаРеглОборот
	               |			КОГДА ФинНачисленияОб.РасходДоход = &Расходование
	               |				ТОГДА -ФинНачисленияОб.СуммаРеглОборот
	               |			ИНАЧЕ 0
	               |		КОНЕЦ) КАК СуммаРегл,
	               |	СУММА(ВЫБОР
	               |			КОГДА ФинНачисленияОб.РасходДоход = &Поступление
	               |				ТОГДА ФинНачисленияОб.СуммаВзаиморасчетыОборот
	               |			КОГДА ФинНачисленияОб.РасходДоход = &Расходование
	               |				ТОГДА -ФинНачисленияОб.СуммаВзаиморасчетыОборот
	               |			ИНАЧЕ 0
	               |		КОНЕЦ) КАК СуммаВзаиморасчеты
	               |ИЗ
	               |	РегистрНакопления.бит_му_ФинансовыеНачисления.Обороты(
	               |			,
	               |			&КонецПериодаФикс,
	               |			Период,
	               |			ДоговорКонтрагента = &ДоговорКонтрагента
	               |				И Контрагент = &Контрагент
	               |				И Объект = &Объект
	               |				И Организация = &Организация
	               |				И ВидСтавки = &ВидСтавки
	               |				И ВидИсточникаЗадолженности = &ВидИсточникаЗадолженности) КАК ФинНачисленияОб";
	
				   
	СтрРез = Новый Структура("СуммаРегл
	                          |, СуммаВзаиморасчеты
							  |, СуммаПлатежаРегл
							  |, СуммаПлатежаВзаиморасчеты
							  |, ПогашеннаяСуммаФинансовыхПроцентовРегл
							  |, ПогашеннаяСуммаФинансовыхПроцентовВзаиморасчеты
							  |, НачисленнаяСуммаФинансовыхПроцентовРегл
							  |, НачисленнаяСуммаФинансовыхПроцентовВзаиморасчеты",0,0,0,0,0,0,0,0);			   
	
	
	
	СтрРез.СуммаПлатежаРегл          = СтрПлатежи.СуммаРегл;
	СтрРез.СуммаПлатежаВзаиморасчеты = СтрПлатежи.СуммаВз;
	
	МассивРезультатов = Запрос.ВыполнитьПакет();	
	
	// Погашенные проценты в текущем периоде
	Выборка = МассивРезультатов[0].Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Если ЭтотОбъект.ВариантРасчетаПроцентов = Перечисления.бит_му_ВариантыРасчетаФинансовыхПроцентов.Аванс Тогда
			
			ПогашенныеПроцентыРегл = ?(ЗначениеЗаполнено(Выборка.ПогашеннаяСуммаФинансовыхПроцентовРегл),Выборка.ПогашеннаяСуммаФинансовыхПроцентовРегл,0);
			ПогашенныеПроцентыВз   = ?(ЗначениеЗаполнено(Выборка.ПогашеннаяСуммаФинансовыхПроцентовВзаиморасчеты),Выборка.ПогашеннаяСуммаФинансовыхПроцентовВзаиморасчеты,0);
			СтрРез.ПогашеннаяСуммаФинансовыхПроцентовРегл          = Мин(ПогашенныеПроцентыРегл, СтрРез.СуммаПлатежаРегл);
			СтрРез.ПогашеннаяСуммаФинансовыхПроцентовВзаиморасчеты = Мин(ПогашенныеПроцентыВз, СтрРез.СуммаПлатежаВзаиморасчеты);
			
		Иначе	
			
			СтрРез.ПогашеннаяСуммаФинансовыхПроцентовРегл          = 0;
			СтрРез.ПогашеннаяСуммаФинансовыхПроцентовВзаиморасчеты = 0;
			
		КонецЕсли; 
		
	КонецЕсли; 
	
	// Непогашенная сумма, которую нужно сторнировать.
	Выборка = МассивРезультатов[1].Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		СтрРез.СуммаРегл          = ?(ЗначениеЗаполнено(Выборка.СуммаРегл),-Выборка.СуммаРегл,0);
		СтрРез.СуммаВзаиморасчеты = ?(ЗначениеЗаполнено(Выборка.СуммаВзаиморасчеты),-Выборка.СуммаВзаиморасчеты,0);
	
	КонецЕсли; 
	
	Возврат СтрРез;
	
КонецФункции // ПолучитьДанныеДляКорректировки()

// Функция получает скорректированную сумму платежа в указанном периоде.
// 
// Параметры:
//  ТекПериод - Период.
//  СтруктураКурсыВалют - Структура.
//  ГрафикНачислений - ТабличнаяЧасть.
// 
// Возвращаемое значение:
//  РезСтруктура - Структура.
// 
Функция ПолучитьСуммуПлатежаКоррект(ТекПериод, СтруктураКурсыВалют, ГрафикНачислений) 

	РезСтруктура = Новый Структура("СуммаРегл,СуммаВз",0,0);

	НачПериода = НачалоМесяца(ТекПериод);
	КонПериода = КонецМесяца(ТекПериод);
	
	Для каждого СтрокаТаблицы Из ГрафикНачислений Цикл
	
		Если СтрокаТаблицы.Период >= НачПериода И СтрокаТаблицы.Период <= КонПериода Тогда
		
			 РезСтруктура.СуммаРегл = РезСтруктура.СуммаРегл + бит_КурсыВалют.ПересчитатьДокРегл(СтрокаТаблицы.Сумма ,СтруктураКурсыВалют); 
			 РезСтруктура.СуммаВз   = РезСтруктура.СуммаВз + бит_КурсыВалют.ПересчитатьДокВзаиморасчеты(СтрокаТаблицы.Сумма,СтруктураКурсыВалют);
		
		КонецЕсли; 
	
	КонецЦикла; 
	
	Возврат РезСтруктура;
	
КонецФункции // ПолучитьСуммуПлатежаКоррект()

// Процедура выполняет движения по регистрам.
// 
// Параметры:
//  СтруктураШапкиДокумента - Структура.
//  СтруктураТаблиц 		- Структура.
//  СтруктураКурсыВалют 	- Структура.
//  Отказ 					- Булево.
//  Заголовок 				- Строка.
// 
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, СтруктураТаблиц, СтруктураКурсыВалют, Отказ, Заголовок)
	
	ТаблицаДанных = СтруктураТаблиц.ГрафикНачислений;
	
    // По новым требованиям корректировку начинаем с даты документа.
	ДатаКорректировок = НачалоМесяца(Документы.бит_му_КорректировкаГрафиковФинансовыхНачислений.ДатаНачалаКорректировок(ЭтотОбъект));	
	// Начало периода изменений
	ДатаНачалаИзмен   = НачалоМесяца(ДобавитьМесяц(ДатаКорректировок,1));
	
	// Проверим: пользователь не может редактировать суммы,
	// если после даты были события начисления процентов или реклассификации.
	ПроверитьДатуНачалаКорректировок(ДатаКорректировок, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	СпособРасчетаЭСП = ОпределитьСпособРасчетаЭСП();
	ТабГрафикНачислений = ПолучитьГрафикНачислений(ДатаКорректировок);
	ТабГрафикНачислений.Колонки.Добавить("Активность");
	ТабГрафикНачислений.ЗаполнитьЗначения(Истина, "Активность");
	
	// Сделаем сторнирующие записи по графику начислений.
	СформироватьДвиженияСторно(ТабГрафикНачислений);
	
	ФинансовыйГрафик = ПолучитьФинансовыйГрафик(СтруктураКурсыВалют, ДатаНачалаИзмен, Истина);	
	Если ФинансовыйГрафик.Количество() > 0 Тогда
	
		ДатаНач = ФинансовыйГрафик[0].Период;
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Не удалось получить финансовый график. Проверьте правильность заполнения табличной части.'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		
		Отказ = Истина;
		Возврат;
	
	КонецЕсли; 
	
	СтрПлатежи = ПолучитьСуммуПлатежаКоррект(ДатаНач, СтруктураКурсыВалют, ГрафикНачислений);
	
	// Сформируем таблицу финансовых начислений по эффективной ставке.
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Дата"                     , ДатаНач);
	СтруктураПараметров.Вставить("Организация"              , СтруктураШапкиДокумента.Организация);
	СтруктураПараметров.Вставить("Контрагент"               , СтруктураШапкиДокумента.Контрагент);
	СтруктураПараметров.Вставить("ДоговорКонтрагента"       , СтруктураШапкиДокумента.ДоговорКонтрагента);
	СтруктураПараметров.Вставить("Объект"                   , СтруктураШапкиДокумента.Объект);
	СтруктураПараметров.Вставить("ВариантРасчетаПроцентов"  , СтруктураШапкиДокумента.ВариантРасчетаПроцентов);
	СтруктураПараметров.Вставить("ВидСтавки"                , Перечисления.бит_му_ВидыСтавокФинансовыхПроцентов.ЭффективнаяСтавкаПроцента);
	СтруктураПараметров.Вставить("ВидИсточникаЗадолженности", ВидИсточникаЗадолженности);
	СтруктураПараметров.Вставить("Ставка"                   , СтавкаЭСП);
	СтруктураПараметров.Вставить("СпособРасчетаЭСП"         , СпособРасчетаЭСП);
	
	Если СпособРасчетаЭСП = Перечисления.бит_му_СпособыРасчетаЭСП.ПоДням Тогда
	
		СтруктураПараметров.Вставить("Периодичность", "День");
	
	КонецЕсли; 
	
	
	Стоимость = бит_КурсыВалют.ПересчитатьДокРегл(НепогашеннаяСтоимостьПоЭффективнойСтавке
	                                                    ,СтруктураКурсыВалют);
	СтоимостьВзаиморасчеты = бит_КурсыВалют.ПересчитатьДокВзаиморасчеты(НепогашеннаяСтоимостьПоЭффективнойСтавке
	                                                                          ,СтруктураКурсыВалют);	
	СтруктураПараметров.Вставить("Стоимость"                , Стоимость);
	СтруктураПараметров.Вставить("СтоимостьВзаиморасчеты"   , СтоимостьВзаиморасчеты);	
	
	СтруктураПараметров.Вставить("ФинансовыйГрафик"         , ФинансовыйГрафик);
	// Необходимо списать остатки непогашенных процентов.
	ОстаткиПроцентов = бит_му_ОбщегоНазначения.ПолучитьОстатокНепогашенныхПроцентов(СтруктураПараметров, СтрПлатежи);
	СтруктураПараметров.Вставить("ОстаткиПроцентов",ОстаткиПроцентов);
	
	
	// Набор записей регистра бит_му_ФинансовыеНачисления.
	НаборЗаписей 	= Движения.бит_му_ФинансовыеНачисления;
	ТаблицаДвижений = НаборЗаписей.Выгрузить();
	
	бит_му_ОбщегоНазначения.СформироватьТаблицуФинансовыхНачислений(ТаблицаДвижений
	                                                                 ,СтруктураПараметров
																	 ,СтруктураКурсыВалют);
																	 
	Если ТаблицаДвижений.Количество()>0 Тогда
		// Выполняем корректировки для "сшивки" двух графиков.
		
		ПерваяСтрока = ТаблицаДвижений[0];
		СтрокаКоррект = ТаблицаДвижений.Вставить(0);
		// Заполнение измерений
		ЗаполнитьЗначенияСвойств(СтрокаКоррект, ПерваяСтрока);	
		СтрокаКоррект.Период   = НачалоМесяца(СтрокаКоррект.Период);
		// Заполнение корректировочных сумм
		ДанныеКоррект = ПолучитьДанныеДляКорректировки(ДатаКорректировок
														, Перечисления.бит_му_ВидыСтавокФинансовыхПроцентов.ЭффективнаяСтавкаПроцента
														, СтруктураКурсыВалют
														, СтрПлатежи);	
														
		ЗаполнитьЗначенияСвойств(СтрокаКоррект, ДанныеКоррект);
		
	КонецЕсли; 
																	 
	// Запись проводок в регистр
	НаборЗаписей.мТаблицаДвижений = ТаблицаДвижений;														
	НаборЗаписей.ДобавитьДвижение();
	
	Если ВидИсточникаЗадолженности = Перечисления.бит_му_ВидыИсточниковЗадолженности.КредитыЗаймы Тогда
		
		// Сформируем таблицу финансовых начислений по номинальной ставке.
		НоминальныеСтавки 	= бит_му_ФинИнструменты.ПолучитьНаборНоминальныхСтавок(ДоговорКонтрагента);
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Дата"                     , ДатаНач);
		СтруктураПараметров.Вставить("Организация"              , СтруктураШапкиДокумента.Организация);
		СтруктураПараметров.Вставить("Контрагент"               , СтруктураШапкиДокумента.Контрагент);
		СтруктураПараметров.Вставить("ДоговорКонтрагента"       , СтруктураШапкиДокумента.ДоговорКонтрагента);
		СтруктураПараметров.Вставить("Объект"                   , СтруктураШапкиДокумента.ДоговорКонтрагента);
		СтруктураПараметров.Вставить("ВариантРасчетаПроцентов"  , СтруктураШапкиДокумента.ВариантРасчетаПроцентов);
		СтруктураПараметров.Вставить("ВидСтавки"                , Перечисления.бит_му_ВидыСтавокФинансовыхПроцентов.НоминальнаяСтавкаПроцента);
		СтруктураПараметров.Вставить("ВидИсточникаЗадолженности", ВидИсточникаЗадолженности);
		СтруктураПараметров.Вставить("Ставка"                   , СтавкаНоминальная);
		СтруктураПараметров.Вставить("СпособРасчетаЭСП"         , СпособРасчетаЭСП);
		
		Если СпособРасчетаЭСП = Перечисления.бит_му_СпособыРасчетаЭСП.ПоДням Тогда
			
			СтруктураПараметров.Вставить("Периодичность", "День");
			
		КонецЕсли; 
		
		
		Стоимость = бит_КурсыВалют.ПересчитатьДокРегл(НепогашеннаяСтоимостьПоНоминальнойСтавке
		                                                    ,СтруктураКурсыВалют);
		СтоимостьВзаиморасчеты = бит_КурсыВалют.ПересчитатьДокВзаиморасчеты(НепогашеннаяСтоимостьПоНоминальнойСтавке
		                                                                           ,СтруктураКурсыВалют);	
		СтруктураПараметров.Вставить("Стоимость"                , Стоимость);
		СтруктураПараметров.Вставить("СтоимостьВзаиморасчеты"   , СтоимостьВзаиморасчеты);	
		
		СтруктураПараметров.Вставить("НоминальныеСтавки"        , НоминальныеСтавки);
		СтруктураПараметров.Вставить("ФинансовыйГрафик"         , ФинансовыйГрафик);
	    // Необходимо списать остатки непогашенных процентов.
		 ОстаткиПроцентов = бит_му_ОбщегоНазначения.ПолучитьОстатокНепогашенныхПроцентов(СтруктураПараметров,СтрПлатежи);
		 СтруктураПараметров.Вставить("ОстаткиПроцентов",ОстаткиПроцентов);
		
		// Набор записей регистра бит_му_ФинансовыеНачисления.
		НаборЗаписей 	= Движения.бит_му_ФинансовыеНачисления;
		ТаблицаДвижений = НаборЗаписей.Выгрузить();
		
		бит_му_ОбщегоНазначения.СформироватьТаблицуФинансовыхНачислений(ТаблицаДвижений
		                                                                 ,СтруктураПараметров
																		 ,СтруктураКурсыВалют);
																		 
		Если ТаблицаДвижений.Количество()>0 Тогда
			// Выполняем корректировки для "сшивки" двух графиков.
			
			ПерваяСтрока = ТаблицаДвижений[0];
			СтрокаКоррект = ТаблицаДвижений.Вставить(0);
			// Заполнение измерений
			ЗаполнитьЗначенияСвойств(СтрокаКоррект, ПерваяСтрока);	
			СтрокаКоррект.Период   = НачалоМесяца(СтрокаКоррект.Период);
			// Заполнение корректировочных сумм
			ДанныеКоррект = ПолучитьДанныеДляКорректировки(ДатаКорректировок
			                                                , Перечисления.бит_му_ВидыСтавокФинансовыхПроцентов.НоминальнаяСтавкаПроцента
															, СтруктураКурсыВалют
															, СтрПлатежи);	
			ЗаполнитьЗначенияСвойств(СтрокаКоррект, ДанныеКоррект);
			
		КонецЕсли; 
																		 
		// Запись проводок в регистр
		НаборЗаписей.мТаблицаДвижений = ТаблицаДвижений;														
		НаборЗаписей.ДобавитьДвижение();
		
	КонецЕсли;
	
КонецПроцедуры // ДвиженияПоРегистрам()

#КонецОбласти

#КонецЕсли
