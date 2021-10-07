﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")Тогда 
		ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДанныеЗаполнения);
	КонецЕсли;
	
	ИнтеграцияВЕТИСПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ИнтеграцияИС.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ИнвентаризацияПродукцииВЕТИС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ИнтеграцияИС.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ИнтеграцияИСПереопределяемый.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	ИнтеграцияВЕТИС.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения, "ДвиженияСерийТоваров");
	
	ИнтеграцияИС.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ИнтеграцияВЕТИСПереопределяемый.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
	ИнтеграцияИС.ОчиститьДополнительныеСвойстваДляПроведения(ЭтотОбъект.ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ВыполнятьПроверкиРеквизитовВетИС = Истина;
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ТекущееСостояние = РегистрыСведений.СтатусыДокументовВЕТИС.ТекущееСостояние(Ссылка);
		КонечныеСтатусы = Документы.ИнвентаризацияПродукцииВЕТИС.КонечныеСтатусы(Ложь);
		Если КонечныеСтатусы.Найти(ТекущееСостояние.Статус) <> Неопределено Тогда
			ВыполнятьПроверкиРеквизитовВетИС = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ВыполнятьПроверкиРеквизитовВетИС Тогда
		ПроверитьЗаполнениеТабличнойЧастиТовары(Отказ);
	КонецЕсли;
	
	ИнтеграцияВЕТИС.ПроверитьЗаполнениеКоличества(ЭтотОбъект, Отказ, МассивНепроверяемыхРеквизитов,, "КоличествоИзменение");
	
	ИнтеграцияВЕТИСПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Идентификатор) Тогда
		Идентификатор = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ИнтеграцияВЕТИС.ЗаписатьСоответствиеНоменклатуры(ЭтотОбъект);
	
	ИнтеграцияВЕТИС.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияВЕТИС.ЗаписатьСтатусДокументаВЕТИСПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование = Неопределено;
	Идентификатор     = "";
	
	СерияАктаНесоответствия = "";
	НомерАктаНесоответствия = "";
	ДатаАктаНесоответствия  = Неопределено;
	ПричинаНесоответствия   = "";
	
	Если Товары.Количество() > 0 Тогда
		Товары.ЗагрузитьКолонку(Новый Массив(Товары.Количество()), "ЗаписьСкладскогоЖурнала");
		Товары.ЗагрузитьКолонку(Новый Массив(Товары.Количество()), "ЗаписьСкладскогоЖурналаАрхив");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьЗаполнениеТабличнойЧастиТовары(Отказ)
	
	ИмяТЧ = "Товары";
	ПредставлениеТЧ = ЭтотОбъект.Метаданные().ТабличныеЧасти[ИмяТЧ].Синоним;
	
	// дата производства, срок годности
	ЗаполнениеДокументовВЕТИС.ПроверитьЗаполнениеДатыПроизводстваСрокаГодности(ЭтотОбъект, ИмяТЧ, Отказ);
	
	// производители при добавлении
	ШаблонСообщения = НСтр("ru = 'Не заполнены производители для продукции ""%1"" в строке %2 списка ""%3""'");
	
	СтруктураОтбора = Новый Структура("ИдентификаторСтрокиТовары");
	
	Для каждого ТекущаяСтрока Из Товары Цикл
		
		СтруктураОтбора.ИдентификаторСтрокиТовары = ТекущаяСтрока.ИдентификаторСтроки;
		
		Если Производители.НайтиСтроки(СтруктураОтбора).Количество() = 0 Тогда
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТЧ, ТекущаяСтрока.НомерСтроки, "Продукция");
			
			ТекстСообщения = СтрШаблон(
				ШаблонСообщения,
				ТекущаяСтрока.Продукция,
				ТекущаяСтрока.НомерСтроки,
				ПредставлениеТЧ);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле,, Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ИнтеграцияВЕТИСВызовСервера.ИспользуетсяОграничениеВыбораПродукцииТретьегоУровня(Дата) Тогда
		
		НомераСтрокСПродукциейТретьегоУровня = ПродукцияВЕТИСВызовСервера.СтрокиТоваровСПродукциейТретьегоУровня(Товары.Выгрузить(, "НомерСтроки, Продукция, ЗаписьСкладскогоЖурнала"));
		
		Для Каждого НомерСтроки Из НомераСтрокСПродукциейТретьегоУровня Цикл
			ТекущаяСтрока = Товары[НомерСтроки-1];
			Если (ТекущаяСтрока.Операция = Перечисления.ОперацииИнвентаризацииПродукцииВЕТИС.Добавление
				Или ТекущаяСтрока.Операция = Перечисления.ОперацииИнвентаризацииПродукцииВЕТИС.Изменение) Тогда
					
				ШаблонСообщения = НСтр("ru = 'В строке №%1 требуется указание четвертого уровня продукции в соответствии с письмом РСХН
				|""О переходе на четвертый уровень справочника подконтрольных товаров с 01 февраля 2019""'");
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Товары.Индекс(ТекущаяСтрока) + 1);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", НомерСтроки, "Продукция"),,
					Отказ);
				
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	ШаблонСообщения = НСтр("ru = 'В строке %1 списка ""%2"" обнаружен дубль записи складского журнала из строки %3'");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Товары", Товары);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Т.НомерСтроки КАК НомерСтроки,
	|	Т.ЗаписьСкладскогоЖурнала КАК ЗаписьСкладскогоЖурнала
	|ПОМЕСТИТЬ ВТТовары
	|ИЗ
	|	&Товары КАК Т
	|ГДЕ
	|	Т.ЗаписьСкладскогоЖурнала <> ЗНАЧЕНИЕ(Справочник.ЗаписиСкладскогоЖурналаВЕТИС.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТТовары.ЗаписьСкладскогоЖурнала КАК ЗаписьСкладскогоЖурнала,
	|	МИНИМУМ(ВТТовары.НомерСтроки) КАК НомерСтроки
	|ИЗ
	|	ВТТовары КАК ВТТовары
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТТовары.ЗаписьСкладскогоЖурнала
	|
	|ИМЕЮЩИЕ
	|	СУММА(1) > 1";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Найдено = Товары.НайтиСтроки(Новый Структура("ЗаписьСкладскогоЖурнала", Выборка.ЗаписьСкладскогоЖурнала));
		Для каждого Строка Из Найдено Цикл
			
			Если Строка.НомерСтроки = Выборка.НомерСтроки Тогда
				Продолжить;
			КонецЕсли;
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТЧ, Строка.НомерСтроки, "ЗаписьСкладскогоЖурнала");
			
			ТекстСообщения = СтрШаблон(ШаблонСообщения, Строка.НомерСтроки, ПредставлениеТЧ, Выборка.НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле,, Отказ);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

