
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
 	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
    
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.СписокПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма);
	
	ЗаполнитьКэшЗначений();
	
	ПустаяОрганизация = Справочники.Организации.ПустаяСсылка();
	
	
	// Параметры списка
	Список.Параметры.УстановитьЗначениеПараметра("Организация"		, ОрганизацияОтбор);
	Список.Параметры.УстановитьЗначениеПараметра("ПустаяОрганизация", ПустаяОрганизация);  	
	
	// Параметры таблицы движений   	
	УстановитьПараметрыТаблицыДвижений(фКэшЗначений.ПустаяСсылка);
	 	
	Если Параметры.Свойство("РегистрБухгалтерии") Тогда
		// Отбор по регистру бухгалтерии
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("РегистрБухгалтерии");
		ЭлементОтбора.ПравоеЗначение = Параметры.РегистрБухгалтерии;
		ЭлементОтбора.Использование  = Истина;
		// Для формы документа
		РегистрБухгалтерииОтбор = Параметры.РегистрБухгалтерии;
        ЭтаФорма.АвтоЗаголовок = Ложь;
        ЭтаФорма.Заголовок = "Операции" + СтрЗаменить(Параметры.РегистрБухгалтерии.Наименование, "Журнал проводок", "");
	КонецЕсли; 	
	
	Если Параметры.Свойство("Организация") Тогда
		// Отбор по организации из параметров
		ОрганизацияОтбор = Параметры.Организация;
		УстановитьПараметрыОсновногоСписка();
	Иначе	
	    // Отбор по основной организации
		ОсновнаяОрганизация = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("ОсновнаяОрганизация");
		Если ЗначениеЗаполнено(ОсновнаяОрганизация) Тогда
			ОрганизацияОтбор = ОсновнаяОрганизация;
			УстановитьПараметрыОсновногоСписка();
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("ДатаВводаОстатков") Тогда
		// Отбор по дате ввода остатков
		ДатаВводаОстатковОтбор = Параметры.ДатаВводаОстатков;
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Дата");
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
		ЭлементОтбора.ПравоеЗначение = КонецДня(ДатаВводаОстатковОтбор);
		ЭлементОтбора.Использование  = Истина;
	Иначе
		Элементы.ДатаВводаОстатковОтбор.Видимость = Ложь;
	КонецЕсли;
	
	Если Не бит_ОбщегоНазначения.ЕстьОбъектыМСФО() Тогда
	 	ЗаголовокПроводкиДоп2 = "Проводки (Журнал проводок (дополнительный 2))";
		Элементы.Страница_бит_Дополнительный_2.Заголовок 	   = ЗаголовокПроводкиДоп2;
		Элементы.Страница_бит_Дополнительный_2.Подсказка 	   = ЗаголовокПроводкиДоп2;
		Элементы.ГруппаПроводки_бит_Дополнительный_2.Заголовок = ЗаголовокПроводкиДоп2;
		Элементы.ГруппаПроводки_бит_Дополнительный_2.Подсказка = ЗаголовокПроводкиДоп2;
	    Элементы.ДвиженияМеждународныйСуммаУпр.Шрифт 		   = Элементы.Движения_бит_Дополнительный_3СуммаУпр.Шрифт;
		Элементы.ДвиженияМеждународныйСуммаУпр.ШрифтЗаголовка  = Элементы.Движения_бит_Дополнительный_3СуммаУпр.Шрифт;
		Элементы.СуммаОперацииМУ.Видимость 	   				   = Ложь;
		Элементы.ДвиженияМеждународныйСуммаМУ.Видимость 	   = Ложь;	
	КонецЕсли;
	
	МетаданныеОбъекта = Метаданные.Документы.бит_ОперацияУправленческий;

	// Добавление кнопки "Раскрасить по статусам".
	// Также добавляются процедуры: К-Подключаемый_РаскраситьПоСтатусам(), С-ОформитьСписокДокументовПоСтатусам().
	бит_РаботаСДиалогамиСервер.ДобавитьКнопкуРаскраситьПоСтатусам(Элементы, Команды, Элементы.ФормаКоманднаяПанель,
																  МетаданныеОбъекта);
	ОформитьСписокДокументовПоСтатусам(Элементы.РаскраситьПоСтатусам.Пометка, Истина);
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	УстановитьПараметрыОсновногоСписка();
		
КонецПроцедуры // ОрганизацияОтборПриИзменении()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОжиданиеАктивизацииСтрокиСписка", 0.1, Истина);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // СписокПриАктивизацииСтроки()

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область СтандартныеПодсистемыОбработчикиКоманд

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

// Процедура назначается динамически действию кнопки командной панели 
// КоманднаяПанель.РаскраситьПоСтатусам
// (обработчик события "Нажатие" кнопки "РаскраситьПоСтатусам")..
// 
&НаКлиенте
Процедура Подключаемый_РаскраситьПоСтатусам()
	
	Элементы.РаскраситьПоСтатусам.Пометка = Не Элементы.РаскраситьПоСтатусам.Пометка;
	ОформитьСписокДокументовПоСтатусам(Элементы.РаскраситьПоСтатусам.Пометка);	
		
КонецПроцедуры // Подключаемый_РаскраситьПоСтатусам()


&НаКлиенте
Процедура Список1ПереключитьАктивность(Команда)
	
	СписокПереключитьАктивность("бит_Дополнительный_1");
		
КонецПроцедуры // Список1ПереключитьАктивность()

&НаКлиенте
Процедура Список2ПереключитьАктивность(Команда)
	
	СписокПереключитьАктивность("бит_Дополнительный_2");
		
КонецПроцедуры // Список2ПереключитьАктивность()

&НаКлиенте
Процедура Список3ПереключитьАктивность(Команда)
	
	СписокПереключитьАктивность("бит_Дополнительный_3");
		
КонецПроцедуры // Список3ПереключитьАктивность()

&НаКлиенте
Процедура Список4ПереключитьАктивность(Команда)
	
	СписокПереключитьАктивность("бит_Дополнительный_4");
		
КонецПроцедуры // Список4ПереключитьАктивность()

&НаКлиенте
Процедура Список5ПереключитьАктивность(Команда)
	
	СписокПереключитьАктивность("бит_Дополнительный_5");
		
КонецПроцедуры // Список5ПереключитьАктивность()

&НаКлиенте
Процедура ПолучитьДанные(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЭтоЗаполнениеИзДокументаОперации", Истина);
	ПараметрыФормы.Вставить("Режим"					     	  , "Множественный");
	
	ОткрытьФорму("Обработка.бит_ПолучениеДанныхРегистровБухгалтерии.Форма.ФормаУправляемая", ПараметрыФормы, ЭтаФорма);
		
КонецПроцедуры // ПолучитьДанные()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
                 
// Процедура обновляет оформление списка документов по статусам.
// 
// Параметры:
//  ТолькоОчистить - Булево 
// 
&НаСервере
Процедура ОформитьСписокДокументовПоСтатусам(ПометкаКн, ЭтоОткрытие = Ложь)

	Если ЭтоОткрытие И Не ПометкаКн Тогда
		Возврат;	
	КонецЕсли;
	
	МетаданныеОбъекта = Метаданные.Документы.бит_ОперацияУправленческий;	
	
	МасОбъектов = ?(ПометкаКн, бит_РаботаСДиалогамиСервер.ПолучитьМассивОбъектов(МетаданныеОбъекта), Новый Массив);
	бит_РаботаСДиалогамиСервер.ОформитьСписокДокументовПоСтатусам(МасОбъектов, ПометкаКн, ЭтаФорма.УсловноеОформление);
	
	Если Не ЭтоОткрытие Тогда
		// Сохранение значения пометки
		РегистрыСведений.бит_СохраненныеЗначения.СохранитьЗнч(бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь")
																	,МетаданныеОбъекта
																	,"РаскраситьПоСтатусам_Пометка"
																	,ПометкаКн);
	КонецЕсли;
															
КонецПроцедуры // ОформитьСписокДокументовПоСтатусам()

// Процедура заполняет кэш значений, необходимый при работе на клиенте.
// 
&НаСервере
Процедура ЗаполнитьКэшЗначений()

	фКэшЗначений = Новый Структура;
	фКэшЗначений.Вставить("ПустаяСсылка", Документы.бит_ОперацияУправленческий.ПустаяСсылка());
		
КонецПроцедуры // ЗаполнитьКэшЗначений()

// Процедура устанавливает параметры для таблицы движений.
// 
// Параметры:
//  Нет
// 
&НаСервере
Процедура УстановитьПараметрыОсновногоСписка()

	Список.Параметры.УстановитьЗначениеПараметра("Организация", ОрганизацияОтбор);	

КонецПроцедуры // УстановитьПараметрыОсновногоСписка()

// Процедура устанавливает параметры для таблицы движений.
// 
// Параметры:
//  СсылкаНаДокумент      - ДокументСсылка.бит_ОперацияБюджетирование.
//  ТекРегистрБухгалтерии - РегистрБухгалтерииСсылка.
// 
&НаСервере
Процедура УстановитьПараметрыТаблицыДвижений(СсылкаНаДокумент, ТекРегистрБухгалтерии = Неопределено)

	Если ТекРегистрБухгалтерии <> Неопределено И ЗначениеЗаполнено(ТекРегистрБухгалтерии) Тогда
		ИмяРегистрБухгалтерии = ТекРегистрБухгалтерии.ИмяОбъекта;
		Элементы.ПанельПроводок.ТекущаяСтраница = Элементы["Страница_" + ИмяРегистрБухгалтерии];
	КонецЕсли;
		
	Движения_бит_Дополнительный_1.Параметры.УстановитьЗначениеПараметра("Регистратор", СсылкаНаДокумент);
	Движения_бит_Дополнительный_2.Параметры.УстановитьЗначениеПараметра("Регистратор", СсылкаНаДокумент);
	Движения_бит_Дополнительный_3.Параметры.УстановитьЗначениеПараметра("Регистратор", СсылкаНаДокумент);
	Движения_бит_Дополнительный_4.Параметры.УстановитьЗначениеПараметра("Регистратор", СсылкаНаДокумент);
	Движения_бит_Дополнительный_5.Параметры.УстановитьЗначениеПараметра("Регистратор", СсылкаНаДокумент);

КонецПроцедуры // УстановитьПараметрыТаблицыДвижений()

// Процедура - обработчик ожидания активизации строки списка.
// 
&НаКлиенте
Процедура ОжиданиеАктивизацииСтрокиСписка()

	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	СсылкаОтбор = ?(ТекущаяСтрока = Неопределено, фКэшЗначений.ПустаяСсылка, ТекущаяСтрока);
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	ТекРегистрБухгалтерии = ?(ТекущиеДанные = Неопределено, Неопределено, ТекущиеДанные.РегистрБухгалтерии);
	
	УстановитьПараметрыТаблицыДвижений(СсылкаОтбор, ТекРегистрБухгалтерии);
	
КонецПроцедуры // ОжиданиеАктивизацииСтрокиСписка()

// Процедура - обработчик ожидания активизации строки списка.
// 
// Параметры:
//  ИмяРегистраБухгалтерии - Строка.
// 
&НаКлиенте
Процедура СписокПереключитьАктивность(ИмяРегистраБухгалтерии)
		
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	Если НЕ ПереключениеПроводокДоступно(ТекущиеДанные, ИмяРегистраБухгалтерии) Тогда
	    Возврат;
	КонецЕсли; 

	бит_ОбщегоНазначения.ПереключитьАктивностьПроводокДокументаДляРегистраБухгалтерии(
		Элементы.Список.ТекущаяСтрока, ИмяРегистраБухгалтерии);
		
	Проводки = СтрШаблон("Движения_%1", ИмяРегистраБухгалтерии);	
	Элементы[Проводки].Обновить();
	
КонецПроцедуры // СписокПереключитьАктивность()

// Процедура - Переключение проводок доступно определяет допустимость действия "переключение проводок".
//
// Параметры:
//  Объект.
//  ИмяРегистраБухгалтерии - Строка.
//
&НаСервереБезКонтекста 
Функция ПереключениеПроводокДоступно(Объект, ИмяРегистраБухгалтерии)
		
	Возврат бит_КонтрольЗакрытогоПериода.ПереключениеПроводокДоступно(Объект.Ссылка, 
				Объект.Организация, Объект.Дата, ИмяРегистраБухгалтерии);
	
КонецФункции

#КонецОбласти
 