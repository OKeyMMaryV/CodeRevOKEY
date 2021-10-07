﻿
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
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект, Объект);
		
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	// Заполняем кэш значений.	
	ЗаполнитьКэшЗначений(мКэшЗначений);
	
	ЗаполнитьСписокОрганизаций();
	
	ОбновитьСписокДоступныхНастроек(); 
	
	ИзменениеРегистраБухгалтерииСервер();
	
	УстановитьПараметрыВыбораДляСчетов();
	
	Если Параметры.Ключ.Пустая() Тогда
		УстановитьСостояниеДокумента();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Установить заголовок формы.
	УстановитьЗаголовокФормыДокумента();
	
	// ОбъектСистемыПриИзменении(Элементы.ОбъектСистемы);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ТекущийОбъект.СформироватьДанныеДляПроведения();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Вывести в заголовке формы статус документа.
	УстановитьЗаголовокФормыДокумента();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	УстановитьСостояниеДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВыбратьПериодЗавершение" И Источник = УникальныйИдентификатор Тогда	
		
		ВыборПериодаЗавершение(Параметр.Результат, Неопределено);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
		
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "Проведениебит_му_Элиминация";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериметрКонсолидацииПриИзменении(Элемент)
	
	ЗаполнитьСписокОрганизаций();
	
	Если Элементы.Организация.СписокВыбора.Количество() = 1 Тогда
		Объект.Организация = Элементы.Организация.СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполняет список доступных для выбора организаций.
//
&НаСервере
Процедура ЗаполнитьСписокОрганизаций()

	СоставПериметраКонсолидации = ПолучитьСоставПериметраКонсолидации(Объект.Периметр, Объект.Дата);
	
	Элементы.Организация.СписокВыбора.ЗагрузитьЗначения(СоставПериметраКонсолидации);

КонецПроцедуры // ЗаполнитьСписокОрганизаций()

&НаКлиенте
Процедура ОбъектСистемыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокВидовОбъектов = Новый СписокЗначений;
	СписокВидовОбъектов.Добавить(мКэшЗначений.ВидОбъекта);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидыОбъектов"           , СписокВидовОбъектов);
	ПараметрыФормы.Вставить("ТекущийОбъектСистемы"   , Объект.ОбъектСистемы);
	ПараметрыФормы.Вставить("ДоступныеОбъектыСистемы", мКэшЗначений.ДоступныеОбъектыСистемы);
	ОткрытьФорму("ОбщаяФорма.бит_ФормаВыбораОбъектовСистемыУправляемая", ПараметрыФормы, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ОбъектСистемыПриИзменении(Элемент)
	
	// Если ЗначениеЗаполнено(Объект.ОбъектСистемы) Тогда.
	// 	
	// 	НовоеОписаниеТипов = Новый ОписаниеТипов("ПланСчетовСсылка." + ПолучитьИмяПланаСчетов(Объект.ОбъектСистемы));
	// 	Если Элементы.СчетВспомогательный.ОграничениеТипа <> НовоеОписаниеТипов Тогда
	// 	 	Элементы.СчетВспомогательный.ОграничениеТипа = НовоеОписаниеТипов;
	// 	КонецЕсли;
	// 			
	// Иначе
	// 	
	// 	Элементы.СчетВспомогательный.ОграничениеТипа = Новый ОписаниеТипов();
	// 	
	// КонецЕсли;
	
	ИзменениеРегистраБухгалтерииСервер(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектСистемыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Объект.ОбъектСистемы <> ВыбранноеЗначение Тогда		
		Объект.СчетВспомогательный = Неопределено;		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройки
 
&НаКлиенте
Процедура НастройкиПослеУдаления(Элемент)
	
	ОбновитьСписокДоступныхНастроек();
	
КонецПроцедуры
 
&НаКлиенте
Процедура НастройкиНастройкаПриИзменении(Элемент)
	
	ОбновитьСписокДоступныхНастроек();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДоступныеНастройки
 
&НаКлиенте
Процедура ДоступныеНастройкиИспользованиеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДоступныеНастройки.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьИзменениеФлажка(ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область СтандартныеПодсистемыОбработчикиКоманд

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

&НаКлиенте
Процедура КомандаВыборПериода(Команда)
	
	ПараметрыПередачи = Новый Структура(); 
	ПараметрыПередачи.Вставить("ДатаНачала", 	Объект.ДатаНач);
	ПараметрыПередачи.Вставить("ДатаОкончания", Объект.ДатаКон);
	ПараметрыПередачи.Вставить("Контекст", 		УникальныйИдентификатор);
	
	бит_ОбщегоНазначенияКлиент.ВыбратьПериод(ПараметрыПередачи);
	
КонецПроцедуры

// Процедура обработчик оповещения "ВыборПериодаЗавершение".
//
// Параметры:
// Период               - СтандартныйПериод.
// ДополнительныеДанные - Структура.
//
&НаКлиенте 
Процедура ВыборПериодаЗавершение(Период, ДополнительныеДанные) Экспорт

	Если Период <> Неопределено Тогда
	
		Объект.ДатаНач = Период.ДатаНачала;
		Объект.ДатаКон = Период.ДатаОкончания;
	
	КонецЕсли; 
	
КонецПроцедуры	// ВыборПериодаЗавершение

&НаКлиенте
Процедура КомандаУстановитьВсе(Команда)
	
	Для каждого ТекСтр Из ДоступныеНастройки Цикл
		Если НЕ ТекСтр.Использование Тогда
			ТекСтр.Использование = Истина;
			ОбработатьИзменениеФлажка(ТекСтр);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
 
&НаКлиенте
Процедура КомандаСнятьВсе(Команда)

	Для каждого ТекСтр Из ДоступныеНастройки Цикл
		Если ТекСтр.Использование Тогда
			ТекСтр.Использование = Ложь;
			ОбработатьИзменениеФлажка(ТекСтр);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
 
&НаКлиенте
Процедура КомандаИнвертировать(Команда)

	Для каждого ТекСтр Из ДоступныеНастройки Цикл
		ТекСтр.Использование = НЕ ТекСтр.Использование;
		ОбработатьИзменениеФлажка(ТекСтр);
	КонецЦикла;
	
КонецПроцедуры
 
&НаКлиенте
Процедура КомандаОбновить(Команда)

	ОбновитьСписокДоступныхНастроек();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбщиеСлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = бит_ОбщегоНазначения.СостояниеДокумента(Объект);
	
КонецПроцедуры

// Процедура заполняет кэш значений, необходимый при работе на клиенте.
// 
&НаСервере
Процедура ЗаполнитьКэшЗначений(КэшированныеЗначения)

	КэшированныеЗначения = Новый Структура;
 
	мКэшЗначений.Вставить("ПредставлениеОбъекта", Объект.Ссылка.Метаданные().ПредставлениеОбъекта);
	
	мКэшЗначений.Вставить("ВидОбъекта",	  		  Перечисления.бит_ВидыОбъектовСистемы.РегистрБухгалтерии);
	
	// Список выбора доступных регистров бухгалтерии.
	ДоступныеОбъектыСистемы = Новый СписокЗначений;
	
	Для каждого ТекРегистр Из Метаданные.Документы.бит_му_Элиминация.Движения Цикл

		МетаОбъект = ТекРегистр;
		ОбъектСистемы = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(МетаОбъект);

		Если ЗначениеЗаполнено(ОбъектСистемы) Тогда				
			ДоступныеОбъектыСистемы.Добавить(ОбъектСистемы);
		КонецЕсли; 
		
	КонецЦикла;
	
	ДоступныеОбъектыСистемы.СортироватьПоЗначению();
	
	КэшированныеЗначения.Вставить("ДоступныеОбъектыСистемы", ДоступныеОбъектыСистемы);	
	
КонецПроцедуры

// Функция получает состав периметра консолидации на указанную дату.
// 
// Параметры:
//  ПериметрКонсолидации - СправочникСсылка.бит_му_ПериметрыКонсолидации.
//  Период               - Дата.
// 
// Возвращаемое значение:
//  Результат - Массив.
// 
&НаСервере
Функция ПолучитьСоставПериметраКонсолидации(ПериметрКонсолидации, Период)

	ТекстЗапроса = "ВЫБРАТЬ
	               |	бит_му_СоставПериметровКонсолидацииСрезПоследних.Организация
	               |ИЗ
	               |	РегистрСведений.бит_му_СоставПериметровКонсолидации.СрезПоследних(&Период, ПериметрКонсолидации = &ПериметрКонсолидации) КАК бит_му_СоставПериметровКонсолидацииСрезПоследних
	               |ГДЕ
	               |	бит_му_СоставПериметровКонсолидацииСрезПоследних.ТипКонсолидации = ЗНАЧЕНИЕ(Перечисление.бит_му_ТипыКонсолидации.Консолидирующая)
	               |	И (КОНЕЦПЕРИОДА(бит_му_СоставПериметровКонсолидацииСрезПоследних.ДатаОкончания, ДЕНЬ) >= &Период
	               |			ИЛИ бит_му_СоставПериметровКонсолидацииСрезПоследних.ДатаОкончания = &ПустаяДата)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	бит_му_СоставПериметровКонсолидацииСрезПоследних.Организация.Наименование";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("Период", 				Период);
	Запрос.УстановитьПараметр("ПустаяДата",				Дата('00010101'));
	Запрос.УстановитьПараметр("ПериметрКонсолидации", 	ПериметрКонсолидации);
	
	РезультатЗапроса = Запрос.Выполнить();

	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Организация");
	
КонецФункции // ПолучитьСоставПериметраКонсолидации()

// Функция получает имя плана счетов для указанного регистра.
// 
// Параметры:
//  ПериметрКонсолидации - СправочникСсылка.бит_ОбъектыСистемы.
// 
// Возвращаемое значение:
//  Результат - Строка.
// 
&НаСервереБезКонтекста
Функция ПолучитьИмяПланаСчетов(ОбъектСистемыСсылка)

	Возврат Метаданные.РегистрыБухгалтерии[ОбъектСистемыСсылка.ИмяОбъекта].ПланСчетов.Имя;
	
КонецФункции

// Процедура обновляет отбор в динамическом списке "ДоступныеНастройки".
// 
&НаСервере
Процедура ОбновитьСписокДоступныхНастроек()

	ТекстЗапроса = "ВЫБРАТЬ
	               |	ВЫБОР
	               |		КОГДА бит_му_НастройкиЭлиминации.Ссылка В (&СписокНастроек)
	               |			ТОГДА ИСТИНА
	               |		ИНАЧЕ ЛОЖЬ
	               |	КОНЕЦ КАК Использование,
	               |	бит_му_НастройкиЭлиминации.Ссылка КАК Настройка
	               |ИЗ
	               |	Справочник.бит_му_НастройкиЭлиминации КАК бит_му_НастройкиЭлиминации
	               |ГДЕ
	               |	бит_му_НастройкиЭлиминации.ОбъектСистемы = &ОбъектСистемы
	               |	И (НЕ бит_му_НастройкиЭлиминации.ЭтоГруппа)";	
				   
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("ОбъектСистемы",  Объект.ОбъектСистемы);
	Запрос.УстановитьПараметр("СписокНастроек", Объект.Настройки.Выгрузить().ВыгрузитьКолонку("Настройка"));
	
	ДоступныеНастройки.Загрузить(Запрос.Выполнить().Выгрузить());

КонецПроцедуры // ОбновитьСписокДоступныхНастроек()

// Процедура выполняет действия, необъодимые при изменении поля "Объект системы".
// 
// Параметры:
//  ОбновитьНастройки - Булево (По умолчанию = Ложь).
// 
&НаСервере
Процедура ИзменениеРегистраБухгалтерииСервер(ОбновитьНастройки = Ложь)
	
	Если ЗначениеЗаполнено(Объект.ОбъектСистемы) Тогда
		
		НовоеОписаниеТипов = Новый ОписаниеТипов("ПланСчетовСсылка." + ПолучитьИмяПланаСчетов(Объект.ОбъектСистемы));
		
		Если Элементы.СчетВспомогательный.ОграничениеТипа = НовоеОписаниеТипов Тогда
			
			ОбновитьНастройки = Ложь;
			
		Иначе	
			
			// Ограничение типа для вспомогательного счета.
			Элементы.СчетВспомогательный.ОграничениеТипа = НовоеОписаниеТипов;
			// Видимость сценария
			// Элементы.Сценарий.Видимость = Объект.ОбъектСистемы.ИмяОбъекта = "бит_Бюджетирование";
			
		КонецЕсли;
				
	Иначе
		
		// Ограничение типа для вспомогательного счета.
		Элементы.СчетВспомогательный.ОграничениеТипа = Новый ОписаниеТипов();
		// Видимость сценария
		// Элементы.Сценарий.Видимость = Ложь;   		
		
	КонецЕсли;
	
	Если ОбновитьНастройки Тогда
		
		ОбновитьСписокДоступныхНастроек();
		
		Если Объект.Настройки.Количество() > 0 Тогда
			Объект.Настройки.Очистить();		
		КонецЕсли;
		
	КонецЕсли;     	

КонецПроцедуры // ИзменениеРегистраБухгалтерииСервер()
								
#КонецОбласти

#Область ПроцедурыИФункцииОбщегоНазначения

// Процедура устанавливает заголовок формы документа.
// 
&НаКлиенте
Процедура УстановитьЗаголовокФормыДокумента()

 	СтруктураЗаголовка = Новый Структура;
 	СтруктураЗаголовка.Вставить("ЭтоНовый"            , Параметры.Ключ.Пустая());
 	СтруктураЗаголовка.Вставить("ПредставлениеОбъекта", мКэшЗначений.ПредставлениеОбъекта);
 	СтруктураЗаголовка.Вставить("ДокументПроведен"    , Объект.Проведен);
 
 	бит_РаботаСДиалогамиКлиент.УстановитьЗаголовокФормыДокумента(ЭтотОбъект,СтруктураЗаголовка);

КонецПроцедуры // УстановитьЗаголовокФормыДокумента()

// Процедура вызывается при изменении флажка "Использование".
// 
// Параметры:
//  СтрокаТЗ - Строка таблицы значений "ДоступныеНастройки".
// 
&НаКлиенте
Процедура ОбработатьИзменениеФлажка(СтрокаТЗ)

	Если СтрокаТЗ.Использование Тогда
		НоваяСтрока = Объект.Настройки.Добавить();
		НоваяСтрока.Настройка = СтрокаТЗ.Настройка;
	Иначе
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Настройка", СтрокаТЗ.Настройка);
		НайденныеСтроки = Объект.Настройки.НайтиСтроки(ПараметрыОтбора);
		
		Для каждого ТекСтр Из НайденныеСтроки Цикл
			Объект.Настройки.Удалить(ТекСтр);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры // ОбработатьИзменениеФлажка() 

// Процедура устанвливает параметры выбора для элементов формы. 
// 
// Параметры:
//  МассивЭлементов - Массив.
// 
&НаСервере
Процедура УстановитьПараметрыВыбораДляСчетов()

	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить(Элементы.СчетВспомогательный);
	
	бит_РаботаСДиалогамиСервер.УстановитьПараметрыВыбораДляЭлементов(МассивЭлементов);
	
КонецПроцедуры // УстановитьПараметрыВыбораДляСчетов() 


#КонецОбласти

#КонецОбласти