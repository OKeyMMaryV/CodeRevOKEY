﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	МетаданныеОбъекта = Метаданные.Обработки.бит_ЗаполнитьТипыПроводок;
	
	// Вызов механизма защиты
	
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	ЗаполнитьКэшированныеЗначения(фКэшЗначений);
	
	Объект.Период.Вариант = ВариантСтандартногоПериода.ЭтотГод;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбъектСистемыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокВидовОбъектов = Новый СписокЗначений;
	СписокВидовОбъектов.Добавить(фКэшЗначений.ВидОбъектаРегистрБухгалтерии);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидыОбъектов"           ,СписокВидовОбъектов);
	ПараметрыФормы.Вставить("ТекущийОбъектСистемы"   ,Объект.ОбъектСистемы);
	ПараметрыФормы.Вставить("ДоступныеОбъектыСистемы",фКэшЗначений.ДоступныеОбъектыСистемы);
	
	ОткрытьФорму("ОбщаяФорма.бит_ФормаВыбораОбъектовСистемыУправляемая",ПараметрыФормы,Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектСистемыПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.ОбъектСистемы) Тогда
		Возврат;
	КонецЕсли;
	
	ИскомыйОбъект = фКэшЗначений.ДоступныеОбъектыСистемы.НайтиПоЗначению(Объект.ОбъектСистемы);
	
	Если ИскомыйОбъект = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Неверно указан объект системы!'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения,,"Объект.ОбъектСистемы");
		
		Объект.ОбъектСистемы = Неопределено;
		
		Возврат;
	КонецЕсли;
	
	ИнициализацияКомпоновщика();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьОбработку(Команда)
	
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.ОбъектСистемы) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не указан объект системы!'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения,,"Объект.ОбъектСистемы",Отказ);
		
	Иначе
		ИскомыйОбъект = фКэшЗначений.ДоступныеОбъектыСистемы.НайтиПоЗначению(Объект.ОбъектСистемы);
		
		Если ИскомыйОбъект = Неопределено Тогда
			ТекстСообщения = НСтр("ru = 'Неверно указан объект системы!'");
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения,,"Объект.ОбъектСистемы",Отказ);
		КонецЕсли;
		
	КонецЕсли;	
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Получим таблицу с регистраторами
	ПолучитьДокументыСДвижениями();
	
	Если ТаблицаДокументов.Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru='Отсутствуют данные для обработки!'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		
	Иначе
		
		Оповещение = Новый ОписаниеОповещения("ВыполнитьОбработкуЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru='Будет выполнено заполнение типа проводок в движениях по регистру ""%1%"". 
								|Операция может занять продолжительное время. Продолжить?'");
								
		ТекстВопроса = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстВопроса, Объект.ОбъектСистемы);
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура обработчик оповещения "ВыполнитьОбработкуЗавершение".
// 
// Параметры:
// Результат - КодВозвратаДиалога.
// ДополнительныеДанные - Структура.
// 
&НаКлиенте
Процедура ВыполнитьОбработкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если НЕ Результат = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru='Выполняется заполнение типов проводок...'");
	Состояние(ТекстСообщения);
		
	ЗаполнитьТипыПроводок();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборПериода(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ВыборПериодаЗавершение", ЭтотОбъект);
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период = Объект.Период;
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

// Процедура обработчик оповещения "ВыборПериодаЗавершение".
// 
// Параметры:
// Период - Произвольный.
// ДополнительныеДанные - Структура.
// 
&НаКлиенте
Процедура ВыборПериодаЗавершение(Период, ДополнительныеДанные) Экспорт

	Если НЕ Период = Неопределено Тогда
		
		Объект.Период = Период; 
	
	КонецЕсли; 

КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет кэш значений, необходимый при работе на клиенте.
// 
&НаСервере
Процедура ЗаполнитьКэшированныеЗначения(КэшированныеЗначения)
	
	КэшированныеЗначения = Новый Структура;
	
	КэшированныеЗначения.Вставить("ВидОбъектаРегистрБухгалтерии", Перечисления.бит_ВидыОбъектовСистемы.РегистрБухгалтерии);
	
	ДоступныеОбъектыСистемы = Новый СписокЗначений;
	
	МетаРегистрыБухгалтерии = Метаданные.РегистрыБухгалтерии;
	
	Для Каждого ТекущийМетаРегистр Из МетаРегистрыБухгалтерии Цикл
		
		Если НЕ бит_РаботаСМетаданными.ЕстьРеквизит("ТипПроводки", ТекущийМетаРегистр) Тогда
			Продолжить;
		КонецЕсли;
		
		ОбъектСистемы = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(ТекущийМетаРегистр);
		
		Если ЗначениеЗаполнено(ОбъектСистемы) Тогда
			
			ДоступныеОбъектыСистемы.Добавить(ОбъектСистемы);
			
		КонецЕсли;
		
	КонецЦикла;
	
	КэшированныеЗначения.Вставить("ДоступныеОбъектыСистемы", ДоступныеОбъектыСистемы);
	
КонецПроцедуры

// Процедура выполняет инициализацию компоновщика настроек.
// 
// 
&НаСервере
Процедура ИнициализацияКомпоновщика()

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаРегистра.Регистратор
	|{ВЫБРАТЬ
	|	Регистратор.*}
	|ИЗ
	|	РегистрБухгалтерии."+Объект.ОбъектСистемы.ИмяОбъекта+" КАК ТаблицаРегистра
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &ДатаНачала = &ПустаяДата
	|					И &ДатаОкончания = &ПустаяДата
	|				ТОГДА ИСТИНА
	|			КОГДА &ДатаНачала <> &ПустаяДата
	|					И &ДатаОкончания <> &ПустаяДата
	|				ТОГДА ТаблицаРегистра.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
	|			КОГДА &ДатаНачала = &ПустаяДата
	|					И &ДатаОкончания <> &ПустаяДата
	|				ТОГДА ТаблицаРегистра.Период <= &ДатаОкончания
	|			КОГДА &ДатаНачала <> &ПустаяДата
	|					И &ДатаОкончания = &ПустаяДата
	|				ТОГДА ТаблицаРегистра.Период >= &ДатаНачала
	|		КОНЕЦ
	|{ГДЕ
	|	ТаблицаРегистра.Организация.*}
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаРегистра.Регистратор";
	
	СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	
	ИсточникДанных = СхемаКомпоновкиДанных.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя 				  = "ИсточникДанных";
	ИсточникДанных.ТипИсточникаДанных = "local";
	
	НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя 						= "НаборДанных"; 
	НаборДанных.ИсточникДанных 				= "ИсточникДанных";
	НаборДанных.Запрос 						= ТекстЗапроса;
	НаборДанных.АвтоЗаполнениеДоступныхПолей= Истина;
	
	НовоеПоле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
	НовоеПоле.Заголовок 	= "Регистратор";
	НовоеПоле.Поле 			= "Регистратор";
	НовоеПоле.ПутьКДанным 	= "Регистратор";
	
	ОтборСКД = СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Отбор;
	
	НовыйОтбор = ОтборСКД.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйОтбор.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Организация");
	НовыйОтбор.ВидСравнения 	= ВидСравненияКомпоновкиДанных.Равно;
	НовыйОтбор.Использование	= Ложь;
	НовыйОтбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	НовыйОтбор.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор; // Это чтобы поле отображалось на форме в пользовательских настройках.
	
	// Определим структуру возвращаемой таблицы
	ГруппировкаКомпоновки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	
	ВыбранноеПоле = ГруппировкаКомпоновки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Использование = Истина;
	ВыбранноеПоле.Заголовок 	= "Регистратор";
	ВыбранноеПоле.Поле      	= Новый ПолеКомпоновкиДанных("Регистратор");
	
	ПолеГруппировки = ГруппировкаКомпоновки.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Использование  = Истина;
	ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Регистратор");
	ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
	ПолеГруппировки.ТипДополнения  = ТипДополненияПериодаКомпоновкиДанных.БезДополнения;
	
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных);
	
	Объект.КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	Объект.КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
КонецПроцедуры // ИнициализацияЗапроса()

// Функция получает регистраторы.
// 
// Возвращаемое значение:
//   ТаблицаРегистраторов   - ТаблицаЗначений.
// 
&НаСервере
Процедура ПолучитьДокументыСДвижениями()
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	
	ПараметрыСКД = Объект.КомпоновщикНастроек.Настройки.ПараметрыДанных;
	
	ПараметрыСКД.УстановитьЗначениеПараметра("ДатаНачала"   ,Объект.Период.ДатаНачала);
	ПараметрыСКД.УстановитьЗначениеПараметра("ДатаОкончания",Объект.Период.ДатаОкончания);
	ПараметрыСКД.УстановитьЗначениеПараметра("ПустаяДата"   ,Дата('00010101'));
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,
												Объект.КомпоновщикНастроек.ПолучитьНастройки(),
												,
												,
												Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	ТаблицаРезультат = Новый ТаблицаЗначений;
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	ТаблицаДокументов.Загрузить(ТаблицаРезультат);
	
КонецПроцедуры // ПолучитьРегистраторыДляОчистки()

// Процедура добавляет текст в протокол.
// 
// Параметры:
// 	ТекстСообщения - строка
// 
&НаСервере
Процедура ДобавитьТекстВПротокол(ТекстСообщения)
	
	Объект.ПротоколВыполнения = Объект.ПротоколВыполнения + Символы.ПС + ТекстСообщения;
	
КонецПроцедуры

// Процедура заполняет типы проводок в движениях регистраторов.
// 
// Параметры:
// 	нет
// 
&НаСервере
Процедура ЗаполнитьТипыПроводок()
	
	ТекстСообщения = НСтр("ru='Начало выполнения операции: %1%'");
	ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ТекущаяДатаСеанса());
	ДобавитьТекстВПротокол(ТекстСообщения);
	
	
	Для Каждого ТекСтрока Из ТаблицаДокументов Цикл
		
		МетаРегистратор = ТекСтрока.Регистратор.Метаданные();
		
		НачалоИмени = Сред(МетаРегистратор.Имя, 1, 4);
		ЭтоТиповойДокумент = НЕ НачалоИмени = "бит_";
		
		НаборЗаписей = РегистрыБухгалтерии[Объект.ОбъектСистемы.ИмяОбъекта].СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(ТекСтрока.Регистратор);
		НаборЗаписей.Прочитать();
		
		Для Каждого ТекЗапись Из НаборЗаписей Цикл
			
			Если ЗначениеЗаполнено(ТекЗапись.ТипПроводки) Тогда
				Продолжить;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ТекЗапись.ВидПроводки) Тогда
				ТекЗапись.ТипПроводки = Справочники.бит_ТипыПроводок.КорректировкиЗакрытогоПериода;
			ИначеЕсли ЭтоТиповойДокумент Тогда
				ТекЗапись.ТипПроводки = Справочники.бит_ТипыПроводок.Трансляция;
			КонецЕсли;
			
		КонецЦикла;
				
		ДействиеВыполнено = бит_ОбщегоНазначения.ЗаписатьНаборЗаписейРегистра(НаборЗаписей, "Ошибки");
		
		Если НЕ ДействиеВыполнено Тогда
			ТекстСообщения = НСтр("ru='Не удалось записать набор записей регистра бухгалтерии ""%1%"" документа ""%2%""'");
			ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, Объект.ОбъектСистемы.ИмяОбъекта, ТекСтрока.Регистратор);
			
			ДобавитьТекстВПротокол(ТекстСообщения);
		КонецЕсли;
		
	КонецЦикла;
	
	ТекстСообщения = НСтр("ru='Окончание выполнения операции: %1%'");
	ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ТекущаяДатаСеанса());
	ДобавитьТекстВПротокол(ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти

