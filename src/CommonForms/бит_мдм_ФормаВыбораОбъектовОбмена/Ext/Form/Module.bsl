﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Хранит текущую настройку подключения к информационной базе.
	Перем ИнформационнаяБаза;
	
	Параметры.Свойство("ВидИнформационнойБазы", ВидИнформационнойБазы);
	Параметры.Свойство("ИнформационнаяБаза", ИнформационнаяБаза);
	
	Если НЕ ЗначениеЗаполнено(ВидИнформационнойБазы) И ЗначениеЗаполнено(ИнформационнаяБаза) Тогда
	
		ВидИнформационнойБазы = ИнформационнаяБаза.ВидИнформационнойБазы;
	
	КонецЕсли; 
	
	КомандаОбновитьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаполнить(Команда)
	
	// Находим элементы, отмеченные в дереве
	ВыбранныеОбъекты = Новый Массив;
	
	КоллекцияВерх = ДеревоОбъектов.ПолучитьЭлементы();
	Для каждого СтрокаВерх Из КоллекцияВерх Цикл
	
		КоллекцияЭлементов = СтрокаВерх.ПолучитьЭлементы();
		Для каждого СтрокаОбъект Из КоллекцияЭлементов Цикл
		
			Если СтрокаОбъект.Выполнять Тогда
			
				ОписаниеОбъекта = Новый Структура("Имя, Синоним, Вид", СтрокаОбъект.Имя, СтрокаОбъект.Синоним, СтрокаОбъект.Вид);
				ВыбранныеОбъекты.Добавить(ОписаниеОбъекта);
				
			КонецЕсли; 
		
		КонецЦикла; 
	
	КонецЦикла; 
	
	// Формируем результирующие данные
	ДанныеВыбора = Новый Структура;
	ДанныеВыбора.Вставить("ИмяКласса", "РезультатВыбораОбъектовОбмена");
	ДанныеВыбора.Вставить("ВидИнформационнойБазы", ВидИнформационнойБазы);
	ДанныеВыбора.Вставить("ВыбранныеОбъекты", ВыбранныеОбъекты);
	
	Закрыть(ДанныеВыбора);
	
КонецПроцедуры

&НаСервере
Процедура КомандаОбновитьНаСервере()
	
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(ВидИнформационнойБазы) Тогда
	
		ТекстСообщения =  НСтр("ru = 'Не заполнен вид информационной базы!'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		Отказ = Истина;
	
	КонецЕсли; 
	
	Если НЕ Отказ И НЕ ВидИнформационнойБазы = Справочники.бит_мпд_ВидыИнформационныхБаз.ТекущаяИнформационнаяБаза Тогда
		
		Если НЕ ЗначениеЗаполнено(ВидИнформационнойБазы.НастройкаПодключенияПоУмолчанию) Тогда
			
			ТекстСообщения =  НСтр("ru = 'Не заполнена настройка подключения по умолчанию у вида инфорационной базы ""%1%""!'");
			ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ВидИнформационнойБазы);
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
			Отказ = Истина;
			
		КонецЕсли; 
		
		Если НЕ Отказ И НЕ ВидИнформационнойБазы.НастройкаПодключенияПоУмолчанию.РасположениеБазы = Перечисления.бит_мпд_ВидыРасположенияИнформационныхБаз.RestСервис Тогда
			
			ТекстСообщения =  НСтр("ru = 'Функционал МДМ доступен только при использовании автоматических REST сервисов!'");
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
			Отказ = Истина;
			
		КонецЕсли; 
		
	КонецЕсли; 
	
	
	Если Отказ Тогда
	
		Возврат;
	
	КонецЕсли; 
	
	ДеревоОбъектов.ПолучитьЭлементы().Очистить();
	
	Если ВидИнформационнойБазы = Справочники.бит_мпд_ВидыИнформационныхБаз.ТекущаяИнформационнаяБаза Тогда
		
		ЗаполнитьОбъектыТекущейБазы();
		
	Иначе	
		
		ЗаполнитьОбъектыHTTP();
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновить(Команда)
	КомандаОбновитьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура создаем временное дерево значений для по объектам метаданных.
// 
&НаСервере
Функция ИнициализироватьДеревоВрем()

	ДеревоВрем = Новый ДеревоЗначений;
	ДеревоВрем.Колонки.Добавить("Выполнять", Новый ОписаниеТипов("Булево"));	
	ДеревоВрем.Колонки.Добавить("Имя"      , Новый ОписаниеТипов("Строка"));
	ДеревоВрем.Колонки.Добавить("Синоним"  , Новый ОписаниеТипов("Строка"));
	ДеревоВрем.Колонки.Добавить("Вид"      , Новый ОписаниеТипов("ПеречислениеСсылка.бит_мдм_ВидыОбъектовОбмена"));
	ДеревоВрем.Колонки.Добавить("Картинка");
	
	Возврат ДеревоВрем;

КонецФункции // ИнициализироватьДеревоВрем()

// Функция определяет картинку строки дерева значений по виду объекта.
// 
// Параметры:
//  Вид - ПеречислениеСсылка.бит_мдм_ВидыОбъектовОбмена.
// 
// Возвращаемое значение:
//  Картинка - Картинка.
// 
&НаСервере
Функция ОпределитьКартинкуСтроки(Вид)

	Если Вид = Перечисления.бит_мдм_ВидыОбъектовОбмена.Справочник Тогда
		
		Картинка = БиблиотекаКартинок.Справочник;
		
	ИначеЕсли Вид = Перечисления.бит_мдм_ВидыОбъектовОбмена.РегистрСведений Тогда 	
		
		Картинка = БиблиотекаКартинок.РегистрСведений;
		
	ИначеЕсли Вид = Перечисления.бит_мдм_ВидыОбъектовОбмена.Перечисление Тогда
		
		Картинка = БиблиотекаКартинок.Перечисление;
		
	ИначеЕсли Вид = Перечисления.бит_мдм_ВидыОбъектовОбмена.ПланВидовХарактеристик Тогда	
		
		Картинка = БиблиотекаКартинок.ПланВидовХарактеристик;
		
	ИначеЕсли Вид = Перечисления.бит_мдм_ВидыОбъектовОбмена.Счет Тогда	
		
		Картинка = БиблиотекаКартинок.ПланСчетов;
		
	Иначе	
		
		Картинка = Неопределено;
		
	КонецЕсли;

	Возврат Картинка;
	
КонецФункции // ОпределитьКартинкуСтроки()

// Функция добавляет строку во временное дерево объектов.
// 
// Параметры:
//  СтрокаВерх - СтрокаДереваЗначений.
//  Имя        - Строка.
//  Синоним    - Строка.
//  Вид        - ПеречислениеСсылка.бит_мдм_ВидыОбъектовОбмена.
//  Картинка   - Картинка.
// 
// Возвращаемое значение:
//  СтрокаДерева - СтрокаДереваЗначений.
// 
&НаСервере
Функция ДобавитьСтрокуДерева(СтрокаВерх, Имя, Синоним = "", Вид, Картинка = Неопределено)

	СтрокаДерева = СтрокаВерх.Строки.Добавить();
	СтрокаДерева.Выполнять = Ложь;
	СтрокаДерева.Имя = Имя;
	СтрокаДерева.Синоним = ?(ЗначениеЗаполнено(Синоним), Синоним, Имя);
	СтрокаДерева.Вид = Вид;
	СтрокаДерева.Картинка = Картинка;

	Возврат СтрокаДерева;
	
КонецФункции // ДобавитьСтрокуДерева()

// Функция инициализирует параметры обхода коллекций метаданных.
// 
// Возвращаемое значение:
//  ПараметрыКоллекций - Массив.
// 
&НаСервере
Функция ИнициализироватьПараметрыКоллекций()

	ПараметрыКоллекций = Новый Массив;
	
	ПараметрыКоллекций.Добавить(Новый Структура("ИмяОбъекта, ИмяКоллекции, СинонимКоллекции"
	                                             , "Справочник", "Справочники",  НСтр("ru = 'Справочники'")));
	ПараметрыКоллекций.Добавить(Новый Структура("ИмяОбъекта, ИмяКоллекции, СинонимКоллекции", "РегистрСведений"
	                                             , "РегистрыСведений",  НСтр("ru = 'Регистры сведений'")));
	ПараметрыКоллекций.Добавить(Новый Структура("ИмяОбъекта, ИмяКоллекции, СинонимКоллекции", "ПланВидовХарактеристик"
	                                             , "ПланыВидовХарактеристик",  НСтр("ru = 'Планы видов характеристик'")));
	ПараметрыКоллекций.Добавить(Новый Структура("ИмяОбъекта, ИмяКоллекции, СинонимКоллекции", "Счет"
	                                             , "ПланыСчетов",  НСтр("ru = 'Планы счетов'")));
	ПараметрыКоллекций.Добавить(Новый Структура("ИмяОбъекта, ИмяКоллекции, СинонимКоллекции"
	                                            , "Перечисление", "Перечисления",  НСтр("ru = 'Перечисления'")));

	Возврат ПараметрыКоллекций;
	
КонецФункции // ИнициализироватьПараметрыКоллекций()


// Процедура заполняет дерево для выбора по метаданным текущей базы.
// 
&НаСервере
Процедура ЗаполнитьОбъектыТекущейБазы()
	
	ДеревоВрем = ИнициализироватьДеревоВрем();
	
	ПараметрыКоллекций = ИнициализироватьПараметрыКоллекций();
	
	Для каждого ТекущиеПараметры Из ПараметрыКоллекций Цикл
		
		ТекВид      = Перечисления.бит_мдм_ВидыОбъектовОбмена[ТекущиеПараметры.ИмяОбъекта];
		ТекКартинка = ОпределитьКартинкуСтроки(ТекВид);
		СтрокаКоллекция = ДобавитьСтрокуДерева(ДеревоВрем, ТекущиеПараметры.ИмяКоллекции,  ТекущиеПараметры.СинонимКоллекции, ТекВид, ТекКартинка);
		
		Для каждого МетаОбъект Из Метаданные[ТекущиеПараметры.ИмяКоллекции] Цикл
			
			Если ТекущиеПараметры.ИмяКоллекции = "РегистрыСведений" 
				 И НЕ МетаОбъект.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый Тогда
				 
				// Только независимые регистры сведений 
				Продолжить;
				
			КонецЕсли;	
				
			
			ДобавитьСтрокуДерева(СтрокаКоллекция, МетаОбъект.Имя, МетаОбъект.Имя, ТекВид);
			
		КонецЦикла; 
		СтрокаКоллекция.Строки.Сортировать("Синоним", Истина);
		
	КонецЦикла; 
	
	ЗначениеВДанныеФормы(ДеревоВрем, ДеревоОбъектов);
	
КонецПроцедуры // ЗаполнитьОбъектыТекущейБазы()

// Процедура заполняет дерево объектов удаленной базы по HTTP.
// 
&НаСервере
Процедура ЗаполнитьОбъектыHTTP()

	ДеревоВрем = ИнициализироватьДеревоВрем();
	
	ПараметрыКоллекций = ИнициализироватьПараметрыКоллекций();
	
	Для каждого ТекущиеПараметры Из ПараметрыКоллекций Цикл
		
		ТекВид      = Перечисления.бит_мдм_ВидыОбъектовОбмена[ТекущиеПараметры.ИмяОбъекта];
		ТекКартинка = ОпределитьКартинкуСтроки(ТекВид);
		СтрокаКоллекция = ДобавитьСтрокуДерева(ДеревоВрем, ТекущиеПараметры.ИмяКоллекции,  ТекущиеПараметры.СинонимКоллекции, ТекВид, ТекКартинка);
		
	КонецЦикла; 
	
	НастройкаПодключения = ВидИнформационнойБазы.НастройкаПодключенияПоУмолчанию;
	Ответ = бит_мпд_ПовтИсп.ПолучитьМетаданныеHTTP(НастройкаПодключения, Истина);
	
	Если Ответ.КодСостояния = 200 Тогда
		
		СтрОтвет = Ответ.ПолучитьТелоКакСтроку();
		
		Чтение = Новый ЧтениеXML;
		Чтение.УстановитьСтроку(СтрОтвет);
		
		флДобавить = Ложь;
		Пока Чтение.Прочитать() Цикл
			
			Если Чтение.ТипУзла = ТипУзлаXML.НачалоЭлемента 
				И Чтение.Имя = "EntityType"   Тогда
				
				ИмяОбъектаПолноеАнгл = Чтение.ПолучитьАтрибут("Name");
				НомРазд    = Найти(ИмяОбъектаПолноеАнгл,"_");
				ИмяКласса  = Лев(ИмяОбъектаПолноеАнгл, НомРазд-1);
				ИмяОбъекта = Сред(ИмяОбъектаПолноеАнгл, НомРазд+1);
				
				Вид = Неопределено;
				Если Врег(ИмяКласса) = Врег("Catalog") Тогда
				
					Вид = Перечисления.бит_мдм_ВидыОбъектовОбмена.Справочник;
					
				ИначеЕсли ВРег(ИмяКласса) = ВРег("InformationRegister") Тогда	
				
					Вид = Перечисления.бит_мдм_ВидыОбъектовОбмена.РегистрСведений;
					
				ИначеЕсли ВРег(ИмяКласса) = ВРег("ChartOfCharacteristicTypes") Тогда	
				
					Вид = Перечисления.бит_мдм_ВидыОбъектовОбмена.ПланВидовХарактеристик;
					
				ИначеЕсли ВРег(ИмяКласса) = ВРег("ChartOfAccounts") Тогда	
				
					Вид = Перечисления.бит_мдм_ВидыОбъектовОбмена.Счет;
					
				КонецЕсли; 
				
				Если НЕ ЗначениеЗаполнено(Вид) Тогда
					
					Продолжить;
					
				КонецЕсли; 
				флДобавить = Истина;
				
				
			ИначеЕсли Чтение.ТипУзла = ТипУзлаXML.НачалоЭлемента И Чтение.Имя = "EnumType" Тогда
				
				ИмяОбъекта = Чтение.ПолучитьАтрибут("Name");				
				Вид = Перечисления.бит_мдм_ВидыОбъектовОбмена.Перечисление;
				
				СтрОтбор = Новый Структура("Вид", Вид);
				НайденныеСтроки = ДеревоВрем.Строки.НайтиСтроки(СтрОтбор);
				
				Если НайденныеСтроки.Количество() > 0 Тогда
					
					СтрокаКоллекция = НайденныеСтроки[0];
					ДобавитьСтрокуДерева(СтрокаКоллекция, ИмяОбъекта,,Вид);
					
				КонецЕсли; 
				
			КонецЕсли; 
			
			Если флДобавить 
				 И Чтение.ТипУзла = ТипУзлаXML.НачалоЭлемента 
				 И Чтение.Имя = "PropertyRef" 
				 И Чтение.ПолучитьАтрибут("Name") = "LineNumber" Тогда
			
				 // Это табличная часть - не добавляем
				 флДобавить = Ложь;
			
			КонецЕсли; 
			
			Если Чтение.ТипУзла = ТипУзлаXML.КонецЭлемента 
				 И Чтение.Имя = "EntityType" Тогда
			
				 Если флДобавить Тогда
					 
					 СтрОтбор = Новый Структура("Вид", Вид);
					 НайденныеСтроки = ДеревоВрем.Строки.НайтиСтроки(СтрОтбор);
					 
					 Если НайденныеСтроки.Количество() > 0 Тогда
						 
						 СтрокаКоллекция = НайденныеСтроки[0];
						 ДобавитьСтрокуДерева(СтрокаКоллекция, ИмяОбъекта,,Вид);
						 
					 КонецЕсли; 
					 
				     флДобавить = Ложь;					 
					 
				 КонецЕсли; 
				 
			КонецЕсли; 
			
		КонецЦикла; // Чтение XML 
		
	КонецЕсли; // Есть ответ
	
	Для каждого СтрокаДерева Из ДеревоВрем.Строки Цикл
	
		СтрокаДерева.Строки.Сортировать("Синоним", Истина);
	
	КонецЦикла; 
	
	ЗначениеВДанныеФормы(ДеревоВрем, ДеревоОбъектов);	
	
КонецПроцедуры // ЗаполнитьОбъектыHTTP()

&НаКлиенте
Процедура ДеревоОбъектовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.ДеревоОбъектов.ТекущиеДанные;
	ТекущаяСтрока.Выполнять = НЕ ТекущаяСтрока.Выполнять;
	
КонецПроцедуры

#КонецОбласти
