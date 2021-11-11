﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбрОбъект = ДанныеФормыВЗначение(Параметры.ТекущийОбъект,Тип("ОбработкаОбъект.бит_мто_РаспределениеПотребностей"));
	ЗначениеВДанныеФормы(ОбрОбъект,Объект);
	
	НачальноеЗаполнениеАналитик();
	
	ЗаполнитьКэшЗначений();
	
	СформироватьСписокАналитик();
	
	// Отображение дополнительных измерений в табличных полях.
	бит_МеханизмДопИзмерений.ОтобразитьДополнительныеИзмеренияВТабличномПоле_Управляемая(ЭтаФорма
																	, "Товары"
																	, фКэшЗначений.ИзмеренияДоп
																	, фКэшЗначений.НастройкиИзмерений);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАналитики

&НаКлиенте
Процедура АналитикиЗначениеАналитикиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Аналитики.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Отбор по организации и контрагенту для договора
	Если ЭтоДоговор(ТекущиеДанные.Аналитика) Тогда
		
		МассивПараметров = Новый Массив;
		
		Для каждого СтрокаАналитика Из Объект.Аналитики Цикл
		
			Если ТипЗнч(СтрокаАналитика.ЗначениеАналитики) = Тип("СправочникСсылка.Организации")
				И ЗначениеЗаполнено(СтрокаАналитика.ЗначениеАналитики) Тогда
			
				НовыйПараметр = Новый ПараметрВыбора("Отбор.Организация", СтрокаАналитика.ЗначениеАналитики);
				
				МассивПараметров.Добавить(НовыйПараметр);
				
			КонецЕсли; 
			
			Если ТипЗнч(СтрокаАналитика.ЗначениеАналитики) = Тип("СправочникСсылка.Контрагенты")
				И ЗначениеЗаполнено(СтрокаАналитика.ЗначениеАналитики) Тогда
				
				НовыйПараметр = Новый ПараметрВыбора("Отбор.Владелец", СтрокаАналитика.ЗначениеАналитики);
				
				МассивПараметров.Добавить(НовыйПараметр);
				
			КонецЕсли; 
			
		КонецЦикла; 
		
		Если МассивПараметров.Количество() > 0 Тогда
		
			Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
		
		КонецЕсли; 
		
	КонецЕсли; 
	
	Контейнер = Новый Соответствие;
	Контейнер.Вставить(ТекущиеДанные.ИмяАналитики, ТекущиеДанные.ЗначениеАналитики);
	
	бит_МеханизмДопИзмеренийКлиент.ВыбратьТипСоставнойАналитики(ЭтаФорма
														  	   , Элемент
															   , Контейнер
															   , ТекущиеДанные.ИмяАналитики
															   , СтандартнаяОбработка
															   , фКэшЗначений.НастройкиАналитик);
															   
	ТекущиеДанные.ЗначениеАналитики = Контейнер.Получить(ТекущиеДанные.ИмяАналитики);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикиЗначениеАналитикиПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Аналитики.ТекущиеДанные;
	
	ТекущиеДанные.Выполнять = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикиЗначениеАналитикиОчистка(Элемент, СтандартнаяОбработка)

	ТекущиеДанные = Элементы.Аналитики.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Контейнер = Новый Структура;
	Контейнер.Вставить(ТекущиеДанные.ИмяАналитики, ТекущиеДанные.ЗначениеАналитики);	

	бит_МеханизмДопИзмеренийКлиент.ОбработкаОчисткиДополнительногоИзмерения(Элемент
																			, Контейнер
																		   	, ТекущиеДанные.ИмяАналитики
																		   	, СтандартнаяОбработка
																		   	, фКэшЗначений.НастройкиАналитик);
																		
	ТекущиеДанные.ЗначениеАналитики = Контейнер[ТекущиеДанные.ИмяАналитики];														   
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикиАналитикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("АналитикиАналитикаНачалоВыбораЗавершение", ЭтотОбъект);
	ПоказатьВыборИзСписка(Оповещение, фКэшЗначений.СписокАналитик);
	
КонецПроцедуры

// Процедура окончание процедуры "АналитикиАналитикаНачалоВыбора".
// 
&НаКлиенте 
Процедура АналитикиАналитикаНачалоВыбораЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	ТекущиеДанные = Элементы.Аналитики.ТекущиеДанные;
	
	Если РезультатВыбора <> Неопределено Тогда
	
		ТекущиеДанные.Аналитика = РезультатВыбора.Значение;
		ИзменениеАналитики(ТекущиеДанные.ПолучитьИдентификатор());
	
	КонецЕсли; 
	
КонецПроцедуры // АналитикиАналитикаНачалоВыбораЗавершение()

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИнвертироватьФлажки(Команда)
	бит_РаботаСДиалогамиКлиент.ОбработатьФлагиТаблицы(Объект.Товары, "Выполнять", 2);	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	бит_РаботаСДиалогамиКлиент.ОбработатьФлагиТаблицы(Объект.Товары, "Выполнять", 0);	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	бит_РаботаСДиалогамиКлиент.ОбработатьФлагиТаблицы(Объект.Товары, "Выполнять", 1);
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьТабЧасть(Команда)
	
	ЭтаФорма.ЗакрыватьПриВыборе = Ложь;
	ВыполнитьПерезаполнение();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьТабЧастьИЗакрыть(Команда)
	
	ЭтаФорма.ЗакрыватьПриВыборе = Истина;
	ВыполнитьПерезаполнение();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет кэш значений, необходимый при работе на клиенте.
// 
&НаСервере
Процедура ЗаполнитьКэшЗначений()

	фКэшЗначений = Новый Структура;
	
	// Данные по дополнительным аналитикам
	фКэшЗначений.Вставить("НастройкиИзмерений", бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_НастройкиДополнительныхИзмерений"));
	фКэшЗначений.Вставить("ИзмеренияДоп"      , бит_Бюджетирование.ПолучитьИзмеренияБюджетирования("Дополнительные", "Синоним"));
	// Настройки всех дополнительных аналитик
	фКэшЗначений.Вставить("НастройкиАналитик", бит_МеханизмДопИзмерений.ПолучитьНастройкиДополнительныхАналитик());
	
	фКэшЗначений.Вставить("НастройкиИзмеренийБюджетирования", бит_Бюджетирование.НастройкиИзмеренийБюджетирования());
	
КонецПроцедуры // ЗаполнитьКэшЗначений()

// Процедура заполняет начальными значениями Табличное поле Аналитики. 
// 
&НаСервере
Процедура НачальноеЗаполнениеАналитик()

	// ЦФО
	НоваяСтрока = Объект.Аналитики.Добавить();
	НоваяСтрока.Аналитика = ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.ЦФО;
	ДозаполнитьСтрокуАналитик(НоваяСтрока);
	
	// Статья оборотов
	НоваяСтрока = Объект.Аналитики.Добавить();
	НоваяСтрока.Аналитика = ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.СтатьяОборотов;
	ДозаполнитьСтрокуАналитик(НоваяСтрока);
	
	// Контрагент
	НоваяСтрока = Объект.Аналитики.Добавить();
	НоваяСтрока.Аналитика = ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.Контрагент;
	ДозаполнитьСтрокуАналитик(НоваяСтрока);
	
	// Договор
	НоваяСтрока = Объект.Аналитики.Добавить();
	НоваяСтрока.Аналитика = ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.ДоговорКонтрагента;
	ДозаполнитьСтрокуАналитик(НоваяСтрока);
	
КонецПроцедуры // НачальноеЗаполнениеАналитик()

// Процедура формирует список аналитик для выбора. 
// 
&НаСервере
Процедура СформироватьСписокАналитик()

	Список = Новый СписокЗначений();
	
	Для каждого Эл Из фКэшЗначений.НастройкиИзмеренийБюджетирования Цикл
		
		Если ЗначениеЗаполнено(Эл.Значение) И ЗначениеЗаполнено(Эл.Значение.Аналитика) Тогда
		
			Список.Добавить(Эл.Значение.Аналитика);
			
		ИначеЕсли ЗначениеЗаполнено(Эл.Значение) Тогда 	
			
			Для каждого нЭл Из фКэшЗначений.НастройкиАналитик Цикл
			
				Если Эл.Ключ = нЭл.Ключ Тогда
				
					Список.Добавить(нЭл.Значение.Аналитика);
					Прервать;
					
				КонецЕсли; 
			
			КонецЦикла; 
			
		КонецЕсли; 
	
	КонецЦикла; 

	фКэшЗначений.Вставить("СписокАналитик", Список);
	
КонецПроцедуры // СформироватьСписокАналитик()

// Обрабатывает изменение аналитики в строке таблицы Аналитики. 
// 
// Параметры:
//  ИдСтроки - Число.
// 
&НаСервере
Процедура ИзменениеАналитики(ИдСтроки)
	
	ТекущаяСтрока = Объект.Аналитики.НайтиПоИдентификатору(ИдСтроки);
	ДозаполнитьСтрокуАналитик(ТекущаяСтрока);
	
КонецПроцедуры // ИзменениеАналитики()

// Процедура дозаполняет строку аналитик. 
// 
&НаСервере
Процедура ДозаполнитьСтрокуАналитик(ТекущаяСтрока)

	Если ТекущаяСтрока <> Неопределено Тогда
		
		Если ЗначениеЗаполнено(ТекущаяСтрока.Аналитика) Тогда
			
			ОписаниеТиповАналитики = ТекущаяСтрока.Аналитика.ТипЗначения;
			ТекущаяСтрока.ЗначениеАналитики = ОписаниеТиповАналитики.ПривестиЗначение(ТекущаяСтрока.ЗначениеАналитики);
			
			// Для дополнительных значений аналитик необходимо проверить владельца.
			Если ТипЗнч(ТекущаяСтрока.ЗначениеАналитики) = Тип("СправочникСсылка.бит_ДополнительныеЗначенияАналитик") 
				 И ЗначениеЗаполнено(ТекущаяСтрока.ЗначениеАналитики) Тогда
			
				Если НЕ ТекущаяСтрока.ЗначениеАналитики.Владелец = ТекущаяСтрока.Аналитика Тогда
				
					ТекущаяСтрока.ЗначениеАналитики = Справочники.бит_ДополнительныеЗначенияАналитик.ПустаяСсылка();
				
				КонецЕсли; 
			
			КонецЕсли; 
			
			ТекущаяСтрока.ИмяАналитики = СокрЛП(ТекущаяСтрока.Аналитика.Код);
				
		КонецЕсли;
		
	КонецЕсли; 

КонецПроцедуры // ДозаполнитьСтрокуАналитик()

// Процедура перезаполняет табличную часть документа. 
// 
&НаКлиенте
Процедура ВыполнитьПерезаполнение()

	РезСтруктура = ПерезаполнитьТабЧастьСервер();
	ОповеститьОВыборе(РезСтруктура);

КонецПроцедуры // ВыполнитьПерезаполнение() 

// Функция перезаполняет табличную часть обработки. 
// 
&НаСервере
Функция ПерезаполнитьТабЧастьСервер()

	ТаблицаДляПередачи = Новый ТаблицаЗначений;
	ТаблицаДляПередачи.Колонки.Добавить("ИД");
	ТаблицаДляПередачи.Колонки.Добавить("Аналитика");
	ТаблицаДляПередачи.Колонки.Добавить("ЗначениеАналитики");
	
	// Если указали перезаполнять статью оборотов , то заполняем сначала ее.
	Парам = Новый Структура("Аналитика, Выполнять", ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.СтатьяОборотов, Истина); 
	МассивСтрок = Объект.Аналитики.НайтиСтроки(Парам);
	
	Если МассивСтрок.Количество()>0 Тогда
	
		Для каждого ЭлТЧ Из Объект.Товары Цикл
			
			Если НЕ ЭлТЧ.Выполнять Тогда
				Продолжить;
			КонецЕсли; 
			
			СтрокаТЗ = ТаблицаДляПередачи.Добавить();
			СтрокаТЗ.ИД 				= ЭлТЧ.ПолучитьИдентификатор();
			СтрокаТЗ.Аналитика 			= "СтатьяОборотов";
			СтрокаТЗ.ЗначениеАналитики 	= МассивСтрок[0].ЗначениеАналитики;
			
			ЭлТЧ.СтатьяОборотов = МассивСтрок[0].ЗначениеАналитики;
			ЭлТЧ.ИзмененаСтатья = Истина;
			
		КонецЦикла;	
			
	КонецЕсли; 
	
	Для каждого Эл Из Объект.Аналитики Цикл
	
		Если НЕ Эл.Выполнять Тогда
			Продолжить;
		КонецЕсли;	
		
		Для каждого ЭлТЧ Из Объект.Товары Цикл
			
			Если НЕ ЭлТЧ.Выполнять Тогда
				Продолжить;
			КонецЕсли; 
			
			
			Если Эл.Аналитика = ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.ЦФО Тогда	
				
				ЭлТЧ.ЦФО = Эл.ЗначениеАналитики;
				
				СтрокаТЗ = ТаблицаДляПередачи.Добавить();
				СтрокаТЗ.Аналитика 			= "ЦФО";
				СтрокаТЗ.ЗначениеАналитики 	= Эл.ЗначениеАналитики;
				СтрокаТЗ.ИД = ЭлТЧ.ПолучитьИдентификатор();
				
			ИначеЕсли Эл.Аналитика = ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.СтатьяОборотов Тогда
				
				Продолжить;
				
			Иначе 
				
				Стр = ПроверитьНазначениеАналитикиСтатьеОборотов(Эл.Аналитика, ЭлТЧ.СтатьяОборотов);  
				Если Стр.Назначена Тогда
				
					ЭлТЧ[Стр.Имя] = Эл.ЗначениеАналитики;
					
					СтрокаТЗ = ТаблицаДляПередачи.Добавить();
					СтрокаТЗ.Аналитика 			= Стр.Имя;
					СтрокаТЗ.ЗначениеАналитики 	= Эл.ЗначениеАналитики;
					СтрокаТЗ.ИД = ЭлТЧ.ПолучитьИдентификатор();
					
				ИначеЕсли ЭлТЧ.ИзмененаСтатья Тогда 	
					
					ЭлТЧ[Стр.Имя] = Эл.ЗначениеАналитики;
					
					СтрокаТЗ = ТаблицаДляПередачи.Добавить();
					СтрокаТЗ.Аналитика 			= Стр.Имя;
					СтрокаТЗ.ЗначениеАналитики 	= Неопределено;
					СтрокаТЗ.ИД = ЭлТЧ.ПолучитьИдентификатор();
					
				КонецЕсли; 
				
			КонецЕсли; 
			
		КонецЦикла; 
	
	КонецЦикла; 
	
	РезСтруктура = Новый Структура;
	РезСтруктура.Вставить("ИмяКласса", "РезультатИзмененияРаспределения");
	ХранилищеДанные = бит_ОбщегоНазначения.УпаковатьТаблицуЗначений(Объект.Товары.Выгрузить());
	РезСтруктура.Вставить("ХранилищеДанные", ХранилищеДанные);
	
	Возврат РезСтруктура;
	
КонецФункции // ПерезаполнитьТабЧастьСервер()

// Функция проверяет возможность заполнения аналитики в табличную часть документа. 
// 
&НаСервере
Функция ПроверитьНазначениеАналитикиСтатьеОборотов(Аналитика, СтатьяОборотов)

	вСтруктура = Новый Структура("Назначена, Имя", Ложь, ""); 
	
	Попытка
		
		вСтруктура.Назначена = СтатьяОборотов["Учет_" + СокрЛП(Аналитика.Код)];
		вСтруктура.Имя = СокрЛП(Аналитика.Код);
		Возврат вСтруктура;
	
	Исключение
	
	КонецПопытки; 
	
	// Ищем в назначенных аналитиках
	Счетчик = 0;
	Для Счетчик = Счетчик + 1 По 7 Цикл
	
		Если фКэшЗначений.НастройкиИзмерений["Аналитика_" + Счетчик].Аналитика = Аналитика Тогда
		
			вСтруктура.Назначена = СтатьяОборотов["Учет_Аналитика_" + Счетчик];
			вСтруктура.Имя = "Аналитика_" + Счетчик;
			Возврат вСтруктура;
			
		КонецЕсли; 
	
	КонецЦикла; 
	
	Возврат вСтруктура; 
	
КонецФункции // ПроверитьНазначениеАналитикиСтатьеОборотов()

// Функция проверяет значение аналитики. 
//
&НаСервере
Функция ЭтоДоговор(Аналитика)

	Если Аналитика = ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.ДоговорКонтрагента Тогда
		Возврат Истина;
	КонецЕсли;	
	
	Возврат Ложь;
	
КонецФункции // ЭтоДоговор()

#КонецОбласти
