﻿
#Область СлужебныйПрограммныйИнтерфейс

#Область ОбъектыБиблиотеки

// Открывает форму сопоставления классификатора ЕГАИС с номенклатурой.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой вызывается команда открытия обработки сопоставления,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы сопоставления,
//  ПараметрыОткрытияФормы - Структура - параметры, передаваемые в форму сопоставления.
//  СтандартнаяОбработка - Булево - признак открытия библиотечной формы
//
Процедура ОткрытьФормуСопоставленияКлассификаторовЕГАИС(
	Форма,
	ОповещениеПриЗавершении = Неопределено,
	ПараметрыОткрытияФормы  = Неопределено,
	СтандартнаяОбработка    = Истина) Экспорт
	
	Возврат;
КонецПроцедуры

// Открывает форму выбора алкогольной продукции.
//
// Параметры:
//  ВладелецФормы        - ЭлементФормы - поле в котором осуществляется выбор алкогольной продукции,
//  Реквизиты            - Структура    - параметры открытия формы и фильтры отбора,
//  СтандартнаяОбработка - Булево       - признак открытия библиотечной формы
//
Процедура ОткрытьФормуВыбораАлкогольнойПродукции(ВладелецФормы, Реквизиты, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ПрикладныеДокументы

// Открывает форму выбора документа перемещения товаров.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой вызывается команда выбора документа,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы выбора,
//  Отбор - Структура, ДокументСсылка.ТТНВходящаяЕГАИС - значения реквизитов, по которым нужно отобрать выбираемый документ
//                                                       или ссылка на ТТН ЕГАИС (входящая), по которой будет сформирован отбор.
//
Процедура ОткрытьФормуВыбораДокументаПеремещениеТоваров(Форма, ОповещениеПриЗавершении, Знач Отбор) Экспорт
	
	НовыйОтбор = Новый Структура;
	//НовыйОтбор.Вставить("ЕстьАлкогольнаяПродукция", Истина);
	
	Если ТипЗнч(Отбор) = Тип("ДокументСсылка.ТТНВходящаяЕГАИС") Тогда
		
		СтруктураОтбора = ИнтеграцияЕГАИСВызовСервера.СтруктураОтбораДляВыбораДокументаПоступления(Отбор);
		
		Если ЗначениеЗаполнено(СтруктураОтбора.Организация) Тогда
			НовыйОтбор.Вставить("Организация", СтруктураОтбора.Организация);
		КонецЕсли;
		Если ЗначениеЗаполнено(СтруктураОтбора.ТорговыйОбъект) Тогда
			НовыйОтбор.Вставить("СкладПолучатель", СтруктураОтбора.ТорговыйОбъект);
		КонецЕсли;
		
	Иначе
		
		Если Отбор.Свойство("Организация") Тогда
			НовыйОтбор.Вставить("Организация", Отбор.Организация);
		КонецЕсли;
		Если Отбор.Свойство("ТорговыйОбъект") Тогда
			НовыйОтбор.Вставить("СкладПолучатель", Отбор.ТорговыйОбъект);
		КонецЕсли;
		
	КонецЕсли;
	
	ОткрытьФорму(
		"Документ.ПеремещениеТоваров.ФормаВыбора",
		Новый Структура("Отбор", НовыйОтбор),
		Форма,,,,
		ОповещениеПриЗавершении);
	
КонецПроцедуры

// Открывает форму выбора документа поступления товаров и услуг.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой вызывается команда выбора документа,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы выбора,
//  Отбор - Структура, ДокументСсылка.ТТНВходящаяЕГАИС - значения реквизитов, по которым нужно отобрать выбираемый документ
//                                                       или ссылка на ТТН ЕГАИС (входящая), по которой будет сформирован отбор.
//
Процедура ОткрытьФормуВыбораДокументаПоступлениеТоваровУслуг(Форма, ОповещениеПриЗавершении, Знач Отбор) Экспорт
	
	НовыйОтбор = Новый Структура;
	НовыйОтбор.Вставить("ПометкаУдаления", Ложь);
	
	Если ТипЗнч(Отбор) = Тип("ДокументСсылка.ТТНВходящаяЕГАИС") Тогда
		
		СтруктураОтбора = ИнтеграцияЕГАИСВызовСервера.СтруктураОтбораДляВыбораДокументаПоступления(Отбор);
		
		Если ЗначениеЗаполнено(СтруктураОтбора.Организация) Тогда
			НовыйОтбор.Вставить("Организация", СтруктураОтбора.Организация);
		КонецЕсли;
		Если ЗначениеЗаполнено(СтруктураОтбора.ТорговыйОбъект) Тогда
			НовыйОтбор.Вставить("Склад", СтруктураОтбора.ТорговыйОбъект);
		КонецЕсли;
		Если ЗначениеЗаполнено(СтруктураОтбора.Контрагент) 
			И ТипЗнч(СтруктураОтбора.Контрагент) = Тип("СправочникСсылка.Контрагенты") Тогда
			НовыйОтбор.Вставить("Контрагент", СтруктураОтбора.Контрагент);
		КонецЕсли;
		
	Иначе
		
		Если Отбор.Свойство("Организация") Тогда
			НовыйОтбор.Вставить("Организация", Отбор.Организация);
		КонецЕсли;
		Если Отбор.Свойство("ТорговыйОбъект") Тогда
			НовыйОтбор.Вставить("Склад", Отбор.ТорговыйОбъект);
		КонецЕсли;
		Если Отбор.Свойство("Контрагент") 
			И ТипЗнч(Отбор.Контрагент) = Тип("СправочникСсылка.Контрагенты") Тогда
			НовыйОтбор.Вставить("Контрагент", Отбор.Контрагент);
		КонецЕсли;
		
	КонецЕсли;
	
	ОткрытьФорму(
		"Документ.ПоступлениеТоваровУслуг.ФормаВыбора",
		Новый Структура("Отбор", НовыйОтбор),
		Форма,,,,
		ОповещениеПриЗавершении);
	
КонецПроцедуры

// Открывает форму создания нового документа поступления товаров и услуг на основании ТТН ЕГАИС.
//
// Параметры:
//  ТТНВходящаяЕГАИС - ДокументСсылка.ТТНВходящаяЕГАИС - ссылка на ТТН.
//
Процедура ОткрытьФормуСозданияДокументаПоступленияТоваровНаОснованииТТНЕГАИС(ТТНВходящаяЕГАИС) Экспорт
	
	ПоступлениеТоваровУслугФормыКлиент.СоздатьПоступлениеПоТТНЕГАИС(ТТНВходящаяЕГАИС);
	
КонецПроцедуры

#КонецОбласти

#Область Номенклатура

// Открывает форму подбора номенклатуры.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой вызывается команда открытия обработки сопоставления,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы подбора.
//
Процедура ОткрытьФормуПодбораНоменклатуры(Форма, ОповещениеПриЗавершении = Неопределено) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Открывает форму создания номенклатуры.
// 
// Параметры:
// 	ФормаВладелец - УправляемаяФорма - форма владелец.
// 	Реквизиты     - Структура - параметры формы создания номенклатуры.
Процедура ОткрытьФормуСозданияНоменклатуры(ФормаВладелец, Знач Реквизиты) Экспорт
	
	ПараметрыФормы = Новый Структура;
	Если ЗначениеЗаполнено(Реквизиты) Тогда
		Для Каждого КлючИЗначение Из Реквизиты Цикл
			ПараметрыФормы.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта", ПараметрыФормы, ФормаВладелец);
	
КонецПроцедуры

// Открывает форму выбора номенклатуры.
// 
// Параметры:
// 	ФормаВладелец - УправляемаяФорма - форма владелец.
// 	Реквизиты     - Структура - параметры формы создания номенклатуры.
Процедура ОткрытьФормуВыбораНоменклатуры(ФормаВладелец, Знач Реквизиты) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", ПараметрыФормы, ФормаВладелец);
	
КонецПроцедуры

// Вызывает процедуру обработки выбора номенклатуры, если произошел выбор из формы выбора.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура завершения подбора номенклатуры,
//  ВыбранноеЗначение - Произвольный - результат выбора в подчиненной форме,
//  ИсточникВыбора - УправляемаяФорма - форма, где осуществлен выбор.
//
Процедура ОбработкаВыбораНоменклатуры(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	Если СтрНачинаетсяС(ИсточникВыбора.ИмяФормы, "Справочник.Номенклатура") Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПартнерыИКонтрагенты

// Открывает форму создания нового контрагента.
//
// Параметры:
//  ДанныеКонтрагента - Структура - данные для заполнения нового контрагента. Структура со свойствами:
//   * Наименование - Строка - наименование контрагента,
//   * СокращенноеНаименование - Строка - сокращенное наименование контрагента,
//   * ИНН - Строка - ИНН контрагента,
//   * КПП - Строка - КПП контрагента.
//  Форма  - УправляемаяФорма - форма-владелец.
//
Процедура ОткрытьФормуСозданияКонтрагента(ФормаВладелец, Реквизиты) Экспорт
	
	Основание = Новый Структура;
	Основание.Вставить("ИНН",                     Реквизиты.ИНН);
	Основание.Вставить("КПП",                     Реквизиты.КПП);
	Основание.Вставить("Наименование",            Реквизиты.Наименование);
	Основание.Вставить("НаименованиеПолное", Реквизиты.СокращенноеНаименование);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("Основание", Основание);
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", ПараметрыФормы, ФормаВладелец);
	
КонецПроцедуры


// Открывает форму создания торгового объекта.
// 
// Параметры:
//  Форма     - УправляемаяФорма - форма-владелец.
// 	Реквизиты - Структура - параметры формы создания номенклатуры.
//
Процедура ОткрытьФормуСозданияТорговогоОбъекта(ФормаВладелец, Реквизиты) Экспорт
	
	Основание = Новый Структура;
	Основание.Вставить("Наименование",            Реквизиты.Наименование);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", Основание);
	
	ОткрытьФорму("Справочник.Склады.ФормаОбъекта", ПараметрыФормы, ФормаВладелец);
	
КонецПроцедуры

// Открывает форму выбора контрагента.
// 
// Параметры:
//  ФормаВладелец - УправляемаяФорма - форма-владелец.
// 	Реквизиты     - Структура - параметры формы создания номенклатуры.
// 	Элемент       - ПолеВвода - необязательный, элемент формы в который происходит выбор.
//
Процедура ОткрытьФормуВыбораКонтрагента(ФормаВладелец, Реквизиты, Элемент = Неопределено) Экспорт
	
	Основание = Новый Структура;
	Основание.Вставить("ИНН",                     Реквизиты.ИНН);
	Основание.Вставить("КПП",                     Реквизиты.КПП);
	Основание.Вставить("Наименование",            Реквизиты.Наименование);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", Основание);
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора", ПараметрыФормы, ФормаВладелец);
	
КонецПроцедуры

// Открывает форму выбора торгового объекта.
// 
// Параметры:
//  ФормаВладелец - УправляемаяФорма - форма-владелец.
// 	Реквизиты     - Структура - параметры формы создания номенклатуры.
//
Процедура ОткрытьФормуВыбораТорговогоОбъекта(ФормаВладелец, Реквизиты) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
	
	ОткрытьФорму("Справочник.Склады.ФормаВыбора", ПараметрыФормы, ФормаВладелец);
	
КонецПроцедуры

// Вызывает процедуру обработки выбора номенклатуры, если произошел выбор из формы выбора.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура завершения подбора номенклатуры,
//  ВыбранноеЗначение - Произвольный - результат выбора в подчиненной форме,
//  ИсточникВыбора - УправляемаяФорма - форма, где осуществлен выбор.
//
Процедура ОбработкаВыбораТорговогоОбъекта(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область Серии

// Вызывает процедуру обработки подбора, если произошел выбор из формы подбора.
//
// Параметры:
//  Форма                  - УправляемаяФорма - форма владелец.
//  ВыбраннаяСерия         - Произвольный - результат выбора в подчиненной форме.
//  ИсточникВыбора         - УправляемаяФорма - форма, где осуществлен выбор.
//  ПараметрыЗаполнения    - Структура - см. ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти
Процедура ОбработкаВыбораСерии(Форма, ВыбраннаяСерия, ИсточникВыбора, ПараметрыЗаполнения = Неопределено) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ДополнительныеПараметры) Экспорт
	
	Возврат;

КонецПроцедуры

Процедура ОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ПослеЗаписи(Форма, ПараметрыЗаписи) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Выполняет переопределяемую команду
//
// Параметры:
//  Форма                   - УправляемаяФорма - форма, в которой расположена команда
//  Команда                 - КомандаФормы     - команда формы
//  ДополнительныеПараметры - Структура        - дополнительные параметры.
//
Процедура ВыполнитьПереопределяемуюКоманду(Форма, Команда, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Команда) = Тип("ДекорацияФормы") Тогда 
		
		Если Команда.Имя = "НадписьПолучитьИзЕГАИС" Тогда
			ДанныеСопоставленияОрганизацииЕГАИС = Неопределено;
			
			ИнтеграцияЕГАИСБПВызовСервера.ДанныеСопоставленияОрганизацииЕГАИС(ДанныеСопоставленияОрганизацииЕГАИС, Команда.Подсказка);
			
			Если ДанныеСопоставленияОрганизацииЕГАИС <> Неопределено Тогда
				Параметры = Новый Структура;
				Параметры.Вставить("ЗначенияЗаполнения", Новый Структура("ОрганизацияЕГАИС", ДанныеСопоставленияОрганизацииЕГАИС.ОрганизацияЕГАИС));
				ОткрытьФорму("Документ.ОстаткиЕГАИС.ФормаОбъекта", Параметры);
			КонецЕсли; 
		ИначеЕсли Команда.Имя = "НадписьОтключитьНапоминание" Тогда 
			
			ИнтеграцияЕГАИСБПВызовСервера.ОтключитьНапоминаниеПоОрганизации(Команда.Подсказка);
			
			Команда.Родитель.Родитель.Видимость = Ложь;
			
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
// Параметры:
//   Форма                     - УправляемаяФорма - форма, из которой происходит вызов процедуры.
//   Элемент                   - ЭлементФормы     - элемент-источник события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриВыбореЭлемента(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриАктивизацииЯчейки(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриНачалеРедактирования(Форма, Элемент, НоваяСтрока, Копирование, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении номенклатуры в таблице Товары.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыЗаполнения - Структура - см. функцию ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
//
Процедура ПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения, ПараметрыУказанияСерий = "") Экспорт
	
	ДанныеПродукции = ИнтеграцияЕГАИСБПВызовСервера.ДанныеАлкогольнойПродукции(ТекущаяСтрока.Номенклатура);
	
	Если ТекущаяСтрока.Свойство("ЕдиницаИзмерения") Тогда
		ТекущаяСтрока.ЕдиницаИзмерения = ДанныеПродукции.ЕдиницаИзмерения;
	КонецЕсли;
	
	Если ТекущаяСтрока.Свойство("МаркируемаяАлкогольнаяПродукция") Тогда
		ТекущаяСтрока.МаркируемаяАлкогольнаяПродукция = ДанныеПродукции.Маркируемый;
	КонецЕсли;
	
	Если ТекущаяСтрока.Свойство("НеобходимостьВводаАкцизнойМарки")
		И ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
		ТекущаяСтрока.НеобходимостьВводаАкцизнойМарки = ДанныеПродукции.Маркируемый;
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ЗаполнитьАлкогольнуюПродукцию Тогда
		ДанныеЗаполнения = Новый Структура("Номенклатура, Характеристика, Серия, НоменклатураДляВыбора, АлкогольнаяПродукция, СопоставлениеАлкогольнаяПродукция");
		
		ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, ТекущаяСтрока);
		ИнтеграцияЕГАИСБПВызовСервера.ЗаполнитьАлкогольнуюПродукцию(ДанныеЗаполнения);
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ДанныеЗаполнения);
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки Тогда
		АкцизныеМаркиКлиентСервер.ЗаполнитьИндексАкцизнойМарки(ТекущаяСтрока, "Количество");
	КонецЕсли;
	
КонецПроцедуры

// Выполняет действия при изменении характеристики в таблице Товары.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыЗаполнения - Структура - см. функцию ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
//
Процедура ПриИзмененииХарактеристики(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при создании характеристики в таблице Товары.
//
// Параметры:
//  Форма                - УправляемаяФорма            - форма, в которой произошло событие,
//  ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  Элемент              - ПолеФормы                   - поле, в котором происходит создание характеристики,
//  СтандартнаяОбработка - Булево                      - признак отказа от стандартной обработки события.
//
Процедура ХарактеристикаСоздание(Форма, ТекущаяСтрока, Элемент, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении упаковки в таблице Товары.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыЗаполнения - Структура - см. функцию ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
//
Процедура ПриИзмененииУпаковки(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении количества упаковок в таблице Товары.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыЗаполнения - Структура - см. функцию ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
//
Процедура ПриИзмененииКоличестваУпаковок(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц Тогда
		ТекущаяСтрока.Количество = ТекущаяСтрока.КоличествоУпаковок;
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
		ТекущаяСтрока.Сумма      = Окр(ТекущаяСтрока.Количество * ТекущаяСтрока.Цена, 2);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет действия при изменении количества в таблице Товары.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыЗаполнения - Структура - см. функцию ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
//
Процедура ПриИзмененииКоличества(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
		ТекущаяСтрока.Сумма = Окр(ТекущаяСтрока.Количество * ТекущаяСтрока.Цена, 2);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет действия при изменении цены в таблице Товары.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыЗаполнения - Структура - см. функцию ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
//
Процедура ПриИзмененииЦены(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
		ТекущаяСтрока.Сумма = Окр(ТекущаяСтрока.Количество * ТекущаяСтрока.Цена, 2);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет действия при изменении суммы в таблице Товары.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыЗаполнения - Структура - см. функцию ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
//
Процедура ПриИзмененииСуммы(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	Если ПараметрыЗаполнения.ПересчитатьЦенуПоСумме И ТекущаяСтрока.Количество <> 0 Тогда
		ТекущаяСтрока.Цена = Окр(ТекущаяСтрока.Сумма / ТекущаяСтрока.Количество, 2);
	КонецЕсли;
	
КонецПроцедуры

// Вызывает процедуру обработки подбора, если произошел выбор из формы подбора.
//
// Параметры:
//  Форма                  - УправляемаяФорма - форма владелец.
//  ТекущиеДанные          - ДанныеФормыЭлементКоллекции - строка таблицы товаров.
// 	КэшированныеЗначения   - Структура - Сохраненные значения параметров, используемых при обработке).
//  ПараметрыЗаполнения    - (См. ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти
Процедура ПриИзмененииСерии(Форма, ТекущиеДанные, КэшированныеЗначения = Неопределено, ПараметрыЗаполнения = Неопределено) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при начале выбора характеристики в таблице Товары.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  Элемент - ПолеВвода - элемент формы Характеристика,
//  ДанныеВыбора - СписокЗначений - в обработчике можно сформировать и передать в этом параметре данные для выбора,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура НачалоВыбораХарактеристики(Форма, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при начале выбора упаковки в таблице Товары.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  Элемент - ПолеВвода - элемент формы Упаковка,
//  ДанныеВыбора - СписокЗначений - в обработчике можно сформировать и передать в этом параметре данные для выбора,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура НачалоВыбораУпаковки(Форма, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемоеОборудование

// Вызывается перед обработкой штрихкодов, не привязанных ни к одной номенклатуре.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - процедура, которую нужно вызвать после выполнения обработки,
//  Форма - УправляемаяФорма - форма, в которой отсканировали штрихкоды,
//  ИмяСобытия - Строка - имя события, инициировавшее оповещение,
//  Параметр - Структура - данные для обработки,
//  Источник - Произвольный - источник события.
//
Процедура ОбработкаОповещенияОбработаныНеизвестныеШтрихкоды(ОписаниеОповещения, Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если Источник = "ПодключаемоеОборудование"
		И ИмяСобытия = "НеизвестныеШтрихкоды"
		И Параметр.ФормаВладелец = Форма.УникальныйИдентификатор Тогда
		
		ДанныеШтрихкодов = Новый Массив;
		Для Каждого ПолученныйШтрихкод Из Параметр.ПолученыНовыеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		Для Каждого ПолученныйШтрихкод Из Параметр.ЗарегистрированныеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, ДанныеШтрихкодов);
		
	КонецЕсли;
	
КонецПроцедуры

// В процедуре нужно реализовать алгоритм передачи данных в ТСД.
//
// Параметры:
//  Форма - УправляемаяФорма - форма документа, инициировавшая выгрузку.
//
Процедура ВыгрузитьДанныеВТСД(Форма) Экспорт
	
	Возврат;
	
КонецПроцедуры

// В процедуре нужно реализовать алгоритм заполнения формы данными из ТСД.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - процедура, которую нужно вызвать после заполнения данных формы,
//  Форма - УправляемаяФорма - форма, данные в которой требуется заполнить,
//  РезультатВыполнения - Структура - результат загрузки данных из ТСД (см. МенеджерОборудованияКлиент.ПараметрыВыполненияОперацииНаОборудовании()).
//
Процедура ПриПолученииДанныхИзТСД(ОписаниеОповещения, Форма, РезультатВыполнения) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
