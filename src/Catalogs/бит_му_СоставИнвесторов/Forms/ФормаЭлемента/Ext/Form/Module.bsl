
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект, Объект);
	
	
	
	// Вызов механизма защиты
	
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	// Заполняем кэш значений	
	ЗаполнитьКэшЗначений(мКэшЗначений);
	
	Период = НачалоМесяца(ТекущаяДатаСеанса());
	ПолучитьСоставИнвесторов(Период);
	
	// Заполним список типов для быстрого выбора составного.
	МассивТипов = Метаданные.РегистрыСведений.бит_му_СоставИнвесторов.Измерения.Акционер.Тип.Типы();
	СписокТипов = бит_ОбщегоНазначения.ПодготовитьСписокВыбораТипа(МассивТипов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьСписокВыбораДляНаименования();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПроверитьЗаполнениеТаблицыЗначений(Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	ЗаписатьСоставИнвесторов(Отказ, ТекущийОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ПолучитьСоставИнвесторов(Период);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, Оповещение)
	
	Если Модифицированность Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПериодОбработкаВыбораЗавершение", ЭтотОбъект, Оповещение);
		ТекстВопроса = НСтр("ru = 'Сохранить значения состава инвесторов для'") + " " + Период;
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		Если Оповещение <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(Оповещение);
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - завершение обработчика события "ОбработкаВыбора" поля ввода "Период".
// 
&НаКлиенте
Процедура ПериодОбработкаВыбораЗавершение(Ответ, Оповещение) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Записать();
	КонецЕсли;
	
	Если Оповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Оповещение);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПериодРегулированиеЗавершение", ЭтотОбъект, Направление);
	ПериодОбработкаВыбора(Элементы.Период, Период, Истина, ОписаниеОповещения);	
	
КонецПроцедуры

// Процедура - завершение обработчика события "Регулирование" поля ввода "Период".
// 
&НаКлиенте
Процедура ПериодРегулированиеЗавершение(Результат, Направление) Экспорт
	
	Период = НачалоМесяца(ДобавитьМесяц(Период, Направление));
	ПериодПриИзменении(Элементы.Период);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектИнвестированияПриИзменении(Элемент)
	
	СформироватьСписокВыбораДляНаименования();
	
	Если НЕ ЗначениеЗаполнено(Объект.Наименование) И (Элементы.Наименование.СписокВыбора.Количество() > 0) Тогда
		Объект.Наименование = Элементы.Наименование.СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСоставИнвесторов

&НаКлиенте
Процедура СоставИнвесторовПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ТекущиеДанные = Элементы.СоставИнвесторов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущиеДанные.Период = НачалоМесяца(Период);
	КонецЕсли;
	
	ИтогДоляВЧистыхАктивах 			= СоставИнвесторов.Итог("ДоляВЧистыхАктивах");
	ИтогДоляПривилегированныхАкций 	= СоставИнвесторов.Итог("ДоляПривилегированныхАкций");
	
КонецПроцедуры

&НаКлиенте
Процедура СоставИнвесторовАкционерНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.СоставИнвесторов.ТекущиеДанные;
    бит_РаботаСДиалогамиКлиент.НачалоВыбораСоставного(ЭтотОбъект, Элемент, ТекущиеДанные, "Акционер", СписокТипов, СтандартнаяОбработка);
										
	Если ТипЗнч(ТекущиеДанные.Акционер) = Тип("ПеречислениеСсылка.бит_му_ВидыИнвесторов") Тогда
		СтандартнаяОбработка   					 		= Ложь;
		ТекущиеДанные.Акционер 					 		= мКэшЗначений.НеконтролирующиеАкционеры;
		ТекущиеДанные.ДоляВЧистыхАктивах 		 		= 100 - СоставИнвесторов.Итог("ДоляВЧистыхАктивах") + ТекущиеДанные.ДоляВЧистыхАктивах;
		
		ДоляПривилегированныхАкцийИтог			 		= СоставИнвесторов.Итог("ДоляПривилегированныхАкций");
		Если ДоляПривилегированныхАкцийИтог > 0 Тогда
			ТекущиеДанные.ДоляПривилегированныхАкций 	= 100 - СоставИнвесторов.Итог("ДоляПривилегированныхАкций") + ТекущиеДанные.ДоляПривилегированныхАкций;
		КонецЕсли;
	КонецЕсли;										

КонецПроцедуры

&НаКлиенте
Процедура СоставИнвесторовАкционерОчистка(Элемент, СтандартнаяОбработка)
	
	Элемент.ВыбиратьТип = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьСоставИнвесторов(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандаОбновитьСоставИнвесторовЗавершение", ЭтотОбъект);
	
	ПериодОбработкаВыбора(Элементы.Период, Период, Истина, ОписаниеОповещения);
	
КонецПроцедуры

// Процедура - завершение обработки команды "ОбновитьСоставИнвесторов".
// 
&НаКлиенте
Процедура КомандаОбновитьСоставИнвесторовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ПериодПриИзменении(Элементы.Период);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет кэш значений, необходимый при работе на клиенте.
// 
&НаСервере
Процедура ЗаполнитьКэшЗначений(КэшированныеЗначения)

	КэшированныеЗначения = Новый Структура; 
	КэшированныеЗначения.Вставить("НеконтролирующиеАкционеры", Перечисления.бит_му_ВидыИнвесторов.НеконтролирующиеАкционеры);
	
КонецПроцедуры

// Процедура получает состав инвесторов.
// 
// Параметры:
//  Период - Дата.
// 
&НаСервере
Процедура ПолучитьСоставИнвесторов(Период)

	Результат = Неопределено;
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	бит_му_СоставИнвесторовСрезПоследних.Период,
	               |	бит_му_СоставИнвесторовСрезПоследних.Акционер,
	               |	бит_му_СоставИнвесторовСрезПоследних.ДоляВЧистыхАктивах,
	               |	бит_му_СоставИнвесторовСрезПоследних.ДоляПривилегированныхАкций
	               |ИЗ
	               |	РегистрСведений.бит_му_СоставИнвесторов.СрезПоследних(&Период, СоставИнвесторов = &СоставИнвесторов) КАК бит_му_СоставИнвесторовСрезПоследних
	               |ГДЕ
	               |	бит_му_СоставИнвесторовСрезПоследних.ДоляВЧистыхАктивах <> 0
	               |	ИЛИ бит_му_СоставИнвесторовСрезПоследних.ДоляПривилегированныхАкций <> 0";
				   
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("Период", 		  Период);
	Запрос.УстановитьПараметр("СоставИнвесторов", Объект.Ссылка);
	
	Результат = Запрос.Выполнить().Выгрузить();

	СоставИнвесторов.Загрузить(Результат);
	
	ИтогДоляВЧистыхАктивах 			= СоставИнвесторов.Итог("ДоляВЧистыхАктивах");
	ИтогДоляПривилегированныхАкций 	= СоставИнвесторов.Итог("ДоляПривилегированныхАкций");
	
КонецПроцедуры // ПолучитьСоставИнвесторов()

// Процедура записывает состав инвесторов.
// 
// Параметры:
//   Отказ - Булево, по умолчанию Ложь.
//   СоставИнвесторовОбъект - Справочник объект "бит_му_СоставИнвесторов".
// 
&НаСервере
Процедура ЗаписатьСоставИнвесторов(Отказ, СоставИнвесторовОбъект)

	ПериодЗаписи = НачалоМесяца(Период);
	
	Попытка
		
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.бит_му_СоставИнвесторов");
		ЭлементБлокировкиДанных.УстановитьЗначение("СоставИнвесторов", СоставИнвесторовОбъект.Ссылка);
		ЭлементБлокировкиДанных.УстановитьЗначение("Период", ПериодЗаписи);
		ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
		БлокировкаДанных.Заблокировать();
		
		НаборЗаписей = РегистрыСведений.бит_му_СоставИнвесторов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.СоставИнвесторов.Установить(СоставИнвесторовОбъект.Ссылка);
		НаборЗаписей.Отбор.Период.Установить(ПериодЗаписи);
		
		Для каждого ТекСтр Из СоставИнвесторов Цикл
			
			Если ТекСтр.Период <> ПериодЗаписи Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтр);
			
			НоваяСтрока.СоставИнвесторов = СоставИнвесторовОбъект.Ссылка;
		КонецЦикла;
	
		НаборЗаписей.Записать();
		
	Исключение
		
		ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ОписаниеОшибки()), СоставИнвесторовОбъект,,,Отказ); 
		
	КонецПопытки;

КонецПроцедуры

// Процедура проверяет, правильно ли заполнена таблица значений "СоставИнвесторов".
// 
// Параметры:
//  Отказ - Булево, по умолчанию Ложь.
// 
&НаСервере
Процедура ПроверитьЗаполнениеТаблицыЗначений(Отказ)

	// Выполним проверку: есть ли дублирующиеся строки.
	СтрокаОшибок = "";
	
	ТаблицаЗначений = СоставИнвесторов.Выгрузить();
	ТаблицаЗначений.Колонки.Добавить("Счетчик");
	ТаблицаЗначений.ЗаполнитьЗначения(1, "Счетчик");
	ТаблицаЗначений.Свернуть("Акционер", "Счетчик");
	
	Для каждого ТекСтр Из ТаблицаЗначений Цикл
		Если ТекСтр.Счетчик > 1 Тогда
			СтрокаОшибок = СтрокаОшибок + НСтр("ru = 'в составе инвесторов присутствуют несколько строк с одинаковым акционером ""%1%""'") + Символы.ПС;
			СтрокаОшибок = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(СтрокаОшибок, ТекСтр.Акционер);
		КонецЕсли;
	КонецЦикла;

	// Выполним проверку: заполнены ли необходимые реквизиты.
	РеквизитыДляПроверки = Новый Структура;
	РеквизитыДляПроверки.Вставить("Акционер", НСтр("ru = 'Акционер'"));
	
	Для каждого ТекСтр Из СоставИнвесторов Цикл
		Для каждого ТекРеквизит Из РеквизитыДляПроверки Цикл
			
			Если НЕ ЗначениеЗаполнено(ТекСтр[ТекРеквизит.Ключ]) Тогда
				СтрокаОшибок = СтрокаОшибок + НСтр("ru = 'в строке № %1% не заполнен реквизит ""%2%""'") + Символы.ПС;
				СтрокаОшибок = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(СтрокаОшибок, (СоставИнвесторов.Индекс(ТекСтр) + 1), ТекРеквизит.Значение);
			КонецЕсли;
			
		КонецЦикла;		
	КонецЦикла;
	
	// Выполним проверку: сумма по "ДоляВЧистыхАктивах" должна быть равна 100%.
	Если (СоставИнвесторов.Итог("ДоляВЧистыхАктивах") <> 100) И (СоставИнвесторов.Количество() > 0) Тогда
		СтрокаОшибок = СтрокаОшибок + НСтр("ru = 'сумма по колонке ""%1%"" не равна 100%'") + Символы.ПС;
		СтрокаОшибок = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(СтрокаОшибок, НСтр("ru = 'Доля в чистых активах, %'"));
	КонецЕсли;
	
	// Выполним проверку: сумма по "ДоляПривилегированныхАкций" должна быть равна 100%.
	ДоляПривилегированныхАкцийИтог = СоставИнвесторов.Итог("ДоляПривилегированныхАкций");
	Если (ДоляПривилегированныхАкцийИтог <> 100) И (ДоляПривилегированныхАкцийИтог <> 0) И (СоставИнвесторов.Количество() > 0) Тогда
		СтрокаОшибок = СтрокаОшибок + НСтр("ru = 'сумма по колонке ""%1%"" не равна 100%'") + Символы.ПС;
		СтрокаОшибок = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(СтрокаОшибок, НСтр("ru = 'Доля привилегированных акций, %'"));
	КонецЕсли;
	
	Если СтрокаОшибок <> "" Тогда
		СтрокаОшибок = НСтр("ru = 'Невозможно записать элемент по причине:'") + Символы.ПС + СтрокаОшибок;	
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(СтрокаОшибок, Объект, , Отказ);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеТаблицыЗначений() 

// Процедура формирует список выбора для наименования.
// 
// Параметры:
//  нет.
// 
&НаКлиенте
Процедура СформироватьСписокВыбораДляНаименования()

	Если ЗначениеЗаполнено(Объект.ОбъектИнвестирования) Тогда
		Элементы.Наименование.СписокВыбора.Очистить();
		Элементы.Наименование.СписокВыбора.Добавить(Объект.ОбъектИнвестирования);
	КонецЕсли;

КонецПроцедуры // СформироватьСписокВыбораДляНаименования()

#КонецОбласти

