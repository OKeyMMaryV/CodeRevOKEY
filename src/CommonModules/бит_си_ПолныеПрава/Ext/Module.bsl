﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ УПРАВЛЕНИЯ ПРАВАМИ ДОСТУПА.

#Область ПроцедурыИФункцииУправленияПравамиДоступа



// Проверяет доступность роли для текущего пользователя.
// Если пользователи ИБ отсутствуют, то роль всегда считается доступной.
// 
// Параметры 
// 	ИмяРоли         	 -	Строка, ОбъектМетадан	 Роль или имя роли для проверки.
//                                  
// Возвращаемое значение:
// 	Возврат ...        	 -	Булево                	 Истина - Роль доступна, Ложь - не доступна.
//                      
// 
Функция бит_си_РольДоступна(ИмяРоли) Экспорт
	Если ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() = 0 Тогда
		Возврат Истина;
	КонецЕсли;
	Попытка
		Возврат РольДоступна(ИмяРоли);
	Исключение
		Возврат Ложь;
	КонецПопытки;
КонецФункции // бит_си_РольДоступна()


#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАСТРОЙКИ ИСТОЧНИКОВ СПРАВОЧНОЙ ИНФОРМАЦИИ.

#Область ПроцедурыИФункцииНастройкиИсточниковСправочнойИнформации



// Возвращает список способов определения текущего объекта настройки источников справочной информации.
// 
// Возвращаемое значение:
// 	Возврат ...        	 -	ТаблицаЗначений        	 Таблица доступных способов определения объекта настройки.
// 		Поля
// 		  Имя			 - Строка					 Имя способа получения объекта настройки.
// 		  Представление  - Строка					 Пользовательское представление способа получения объекта настройки.
// 		  Код			 - Строка					 Алгоритм получения объекта настройки.
// 
Функция ПолучитьСписокНастроекПолученияОбъектаНастройки() Экспорт
	СписокНастроек = Новый ТаблицаЗначений();
	СписокНастроек.Колонки.Добавить("Имя",Новый ОписаниеТипов("Строка"));
	СписокНастроек.Колонки.Добавить("Представление",Новый ОписаниеТипов("Строка"));
	СписокНастроек.Колонки.Добавить("Код",Новый ОписаниеТипов("Строка"));
	
	Настройка = СписокНастроек.Добавить();
	Настройка.Имя = "БухгалтерияПредприятия";
	Настройка.Представление = "Бухгалтерия предприятия";
	Настройка.Код = "Результат = ПараметрыСеанса.ТекущийПользователь;";
	
	Настройка = СписокНастроек.Добавить();
	Настройка.Имя = "УправлениеТорговлей";
	Настройка.Представление = "Управление торговлей";
	Настройка.Код = "Результат = ПараметрыСеанса.ТекущийПользователь;";
	
	Настройка = СписокНастроек.Добавить();
	Настройка.Имя = "ЗарплатаИУправлениеПерсоналом";
	Настройка.Представление = "Зарплата и Управление Персоналом";
	Настройка.Код = "Результат = ПараметрыСеанса.ТекущийПользователь;";
	
	Настройка = СписокНастроек.Добавить();
	Настройка.Имя = "УправлениеПроизводственнымПредприятием";
	Настройка.Представление = "Управление производственным предприятием";
	Настройка.Код = "Результат = ПараметрыСеанса.ТекущийПользователь;";
	
	Настройка = СписокНастроек.Добавить();
	Настройка.Имя = "УправлениеСтроительнойОрганизацией";
	Настройка.Представление = "1С:Управление строительной организацией";
	Настройка.Код = "Результат = ПараметрыСеанса.ТекущийПользователь;";
	
	Настройка = СписокНастроек.Добавить();
	Настройка.Имя = "УправляющийСтандарт";
	Настройка.Представление = "1С:Управляющий 8 Стандарт";
	Настройка.Код = "Результат = ПараметрыСеанса.ТекущийПользователь;";
	
	Настройка = СписокНастроек.Добавить();
	Настройка.Имя = "БИТ_РеестрЗамечаний";
	Настройка.Представление = "БИТ: Реестр замечаний";
	Настройка.Код = "Результат = бит_рз_УправлениеПользователями.ПолучитьТекущегоПользователя();";
	
	Настройка = СписокНастроек.Добавить();
	Настройка.Имя = "ПользовательИБИмя";
	Настройка.Представление = "По имени пользователя ИБ";
	Настройка.Код = "Результат = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;";
	
	Настройка = СписокНастроек.Добавить();
	Настройка.Имя = "ПользовательИБИд";
	Настройка.Представление = "По уникальному идентификатору пользователя ИБ";
	Настройка.Код = "Результат = СокрЛП(ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор);";
	
	Возврат СписокНастроек;
КонецФункции // ПолучитьСписокНастроекПолученияОбъектаНастройки()

// Получает текущего пользователя по настройкам источника.
// 
// Параметры 
// 	ИсточникСИ         	 -	СправочникСсылка.бит_си	 Источник справочной информации.
//
// Возвращаемое значение:
// 	Возврат ...        	 -	Строка.
//
// 
Функция ПолучитьТекущийОбъектНастройки(ИсточникСИ) Экспорт
	Если ТипЗнч(ИсточникСИ) = Тип("Строка") Тогда
		Код = ИсточникСИ;
	ИначеЕсли ТипЗнч(ИсточникСИ) = Тип("СправочникСсылка.бит_си_Источники") Тогда
		Попытка
			Код = СокрЛП(ИсточникСИ.ПолучениеТекущегоОбъектаНастройки.Получить().Код);
		Исключение
			Возврат Неопределено;
		КонецПопытки;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	Результат = Неопределено;
	Попытка
		Выполнить(Код);
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	Возврат Результат;
КонецФункции // ПолучитьТекущийОбъектНастройки()

// Получает таблицу настроек для переданного списка пользователей.
// 
// Параметры 
// 	ИсточникСИ         	 -	СправочникСсылка.бит_си	 Источник справочной информации                                   
// 	                   	  	_Источники             	                                                                  
// 	ПарамОбъекты       	 -	Массив,                	 Список пользователей. Если "Неопределено". то возвращает все     
// 	                   	  	СправочникСсылка,      	 настройки.                                                       
// 	                   	  	Строка, Неопределено   	                                                                  
// Возвращаемое значение:
// 	Возврат         	 -	ТаблицаЗначений        	 Таблица пользователей и настроек                                 
// 		Колонки
// 			Объект		-	Строка, СправочникСсылка Пользователь
// 			Настройка	-	ХранилищеЗначения		 Настройка пользователя.
// 
Функция ПолучитьНастройкиИсточника(ИсточникСИ, ПарамОбъекты = Неопределено) Экспорт
	МассивОбъектов = Новый Массив();
	Если НЕ ТипЗнч(ПарамОбъекты) = Тип("Массив") Тогда
		МассивОбъектов.Добавить(ПарамОбъекты);
	Иначе
		МассивОбъектов = ПарамОбъекты;
	КонецЕсли;
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	НастройкиИсточников.Объект,
	                      |	НастройкиИсточников.Настройка
	                      |ИЗ
	                      |	РегистрСведений.бит_си_НастройкиИсточников КАК НастройкиИсточников
	                      |ГДЕ
	                      |	НастройкиИсточников.Источник = &Источник
	                      |	И (НастройкиИсточников.Объект В (&МассивОбъектов)
	                      |			ИЛИ &ВсеОбъекты)");
	
	Запрос.УстановитьПараметр("Источник", ИсточникСИ);
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("ВсеОбъекты", ПарамОбъекты = Неопределено);
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции // ПолучитьНастройкиИсточника()

// Получает настройки источника справочной информации для переданного пользователя
// или настройки по умолчанию, если настроек для пользователя не найдено.
// 
// Параметры 
// 	ИсточникСИ         	 -	СправочникСсылка.бит_си	 Источник справочной информации.
//
// 	ПарамОбъект        	 -	Строка,                	 Пользователь для которого получаем настройку.
//      
// 	Хранилище          	 -	Булево                 	 Истина - Получает в виде хранилища значений; Ложь - в виде.
// 	                   	  	                       	 структуры; По умолчанию - Ложь.
// Возвращаемое значение:
// 	Возврат ...        	 -	ХранилищеЗначения,     	 Найденные настройки, если не найдены. то настройки по умолчанию .
//
// 
Функция ПолучитьНастройкуИсточника(ИсточникСИ, ПарамОбъект = Неопределено, Хранилище = Ложь) Экспорт
	Если ПарамОбъект = Неопределено Тогда
		Возврат ?(Хранилище, ИсточникСИ.НастройкаПоУмолчанию, ИсточникСИ.НастройкаПоУмолчанию.Получить());
	КонецЕсли;
	ТабНастройки = бит_си_ПолныеПрава.ПолучитьНастройкиИсточника(ИсточникСИ, ПарамОбъект);
	Если ТабНастройки.Количество() = 0 Тогда
		Возврат ?(Хранилище, ИсточникСИ.НастройкаПоУмолчанию, ИсточникСИ.НастройкаПоУмолчанию.Получить());
	Иначе
		Возврат ?(Хранилище, ТабНастройки[0].Настройка, ТабНастройки[0].Настройка.Получить());
	КонецЕсли;
КонецФункции // ПолучитьНастройкуИсточника()

// Получает настройки источника справочной информации для текущего пользователя.
// 
// Параметры 
// 	ИсточникСИ         	 -	СправочникСсылка.бит_си	 Источник справочной информации.
//
// 	Хранилище          	 -	Булево                 	 Истина - возвращает настройки в виде хранилища значения; Ложь - в
// 	                   	  	                       	 виде структуры; по умолчанию - Ложь.
// Возвращаемое значение:
// 	Возврат ...        	 -	ХранилищеЗначения,     	 Настройки текущего пользователя.                                 
//
// 
Функция ПолучитьТекущуюНастройкуИсточника(ИсточникСИ, Хранилище = Ложь) Экспорт
	Возврат ПолучитьНастройкуИсточника(ИсточникСИ,
									   бит_си_ПолныеПрава.ПолучитьТекущийОбъектНастройки(ИсточникСИ),
									   Хранилище);
КонецФункции // ПолучитьТекущуюНастройкуИсточника()


#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБНОВЛЕНИЯ МОДУЛЯ

#Область ПроцедурыИФункцииОбновленияМодуля



// Выполняет необходимые действия при обновлении подсистемы справочной информации.
// 
Процедура ВыполнитьОбновление() Экспорт
	
	Возврат;
	ТекВерсия = Константы.бит_си_Версия.Получить();
	Попытка
		вОбработкаОКонфигурации = Обработки["бит_ОКонфигурации"].Создать();
		ОписаниеМодуля = вОбработкаОКонфигурации.ПолучитьОписаниеМодулейИзМакета("ОбщийМакет.бит_си_ОписаниеМодуля");
		Версия = ОписаниеМодуля.Версия.Строка;
	Исключение
		Возврат;
	КонецПопытки;
	Если Версия = ТекВерсия Тогда
		Возврат;
	КонецЕсли;
	Константы.бит_си_Версия.Установить(Версия);
	
	СтруктураВерсии = вОбработкаОКонфигурации.РазобратьВерсию(ТекВерсия);
	
	Если СтруктураВерсии.МаксВерсия = 2 И СтруктураВерсии.МинВерсия = 0 И СтруктураВерсии.Релиз < 26 Тогда
		// Переносим настройку получения объектов настроек в справочнике Источники из удаленного реквизита в новый.
		ТабНастроек = бит_си_ПолныеПрава.ПолучитьСписокНастроекПолученияОбъектаНастройки();
		Выборка = Справочники.бит_си_Источники.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если СокрЛП(Выборка.ПолучениеТекущегоОбъектаНастройки_Удалить) = ""
			 ИЛИ ТипЗнч(Выборка.ПолучениеТекущегоОбъектаНастройки.Получить()) = Тип("Структура") Тогда
				Продолжить;
			КонецЕсли;
			ТекНастройкаПоКоду = ТабНастроек.Найти(Выборка.ПолучениеТекущегоОбъектаНастройки_Удалить,"Код");
			Если ТекНастройкаПоКоду = Неопределено Тогда
				ТекНастройка = Новый Структура("Имя, Представление, Код",
											   "Пользователь",
											   "<Способ получения текущего объекта настройки указан вручную>",
											   Выборка.ПолучениеТекущегоОбъектаНастройки_Удалить);
			Иначе
				ТекНастройка = Новый Структура("Имя, Представление, Код",
											   ТекНастройкаПоКоду.Имя,
											   ТекНастройкаПоКоду.Представление,
											   Выборка.ПолучениеТекущегоОбъектаНастройки_Удалить);
			КонецЕсли;
			СпрОбъект = Выборка.ПолучитьОбъект();
			СпрОбъект.ПолучениеТекущегоОбъектаНастройки_Удалить = "";
			СпрОбъект.ПолучениеТекущегоОбъектаНастройки = Новый ХранилищеЗначения(ТекНастройка);
			Попытка
				СпрОбъект.Записать();
			Исключение
			КонецПопытки;
		КонецЦикла;
	КонецЕсли;
	
	Если СтруктураВерсии.МаксВерсия = 2 И СтруктураВерсии.МинВерсия = 0 И СтруктураВерсии.Релиз < 27 Тогда
	КонецЕсли;
КонецПроцедуры // ВыполнитьОбновление()

// Изменение кода. Начало. 02.04.2012{{

// Функция получает список общих настроек.
// 
// Параметры: 
// Возвращаемое значение:
// 	Возврат СтруктураОтображаемыхЗначений	 -	Структура         	 Структура общих настроек.
// 
Функция ПолучитьОписаниеНастроек() Экспорт
	
	СтруктураНастроек = ХранилищеОбщихНастроек.Загрузить("СправочнаяИнформация",
														 "СправочнаяИнформация",,
														 СокрЛП(ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор));
														 
	Возврат СтруктураНастроек;
	
КонецФункции // ПолучитьОписаниеНастроек()

// Процедура устанавливает описание настроек.
// 
// Параметры: 
// 	Настройка		   	 -	Строка                          Имя настройки.
// 	Объект			   	 -	Строка                          Имя объекта.
// 	СтруктураНастроек 	 -	Структура                       Структура сохраняемых настроек.
// 
Процедура УстановитьОписаниеНастроек(СтруктураНастроек) Экспорт
	
	ХранилищеОбщихНастроек.Сохранить("СправочнаяИнформация",
	             					 "СправочнаяИнформация", 
									 СтруктураНастроек,
						             ,
						             СокрЛП(ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор));
									 
КонецПроцедуры // УстановитьОписаниеНастроек()


// Изменение кода. Конец. 02.04.2012}}
#КонецОбласти

