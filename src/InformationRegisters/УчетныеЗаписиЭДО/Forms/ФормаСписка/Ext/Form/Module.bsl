
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Отбор") Тогда
		ПредопределенныйОтбор = Новый ФиксированнаяСтруктура(Параметры.Отбор);
		
		Если ПредопределенныйОтбор.Свойство("Организация") Тогда
			Заголовок = ОбменСКонтрагентамиВнутренний.ЗаголовокКонтекстнойФормы(
				Метаданные.РегистрыСведений.УчетныеЗаписиЭДО.Синоним, ПредопределенныйОтбор.Организация);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Заголовок) Тогда
		АвтоЗаголовок = Истина;
	КонецЕсли;
	
	УстановитьУсловноеОформлениеСписка();
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата"             , ТекущаяДатаСеанса());
	Список.Параметры.УстановитьЗначениеПараметра("ВсеСертификатыПросрочены", НСтр("ru = 'Все сертификаты просрочены'"));
	Список.Параметры.УстановитьЗначениеПараметра("СертификатыЗаканчиваются", НСтр("ru = 'Заканчивается срок действия сертификатов'"));
	Список.Параметры.УстановитьЗначениеПараметра("Неизвестный", НСтр("ru = 'Неизвестный'"));
	Список.Параметры.УстановитьЗначениеПараметра("ИспользоватьПрямойОбмен",
		ОбменСКонтрагентамиСлужебный.ИспользоватьПрямойОбмен());
	Список.Параметры.УстановитьЗначениеПараметра("СпособыПрямогоОбмена", ОбменСКонтрагентамиСлужебный.СпособыПрямогоОбмена());
	
	Если Не ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.УчетныеЗаписиЭДО) Тогда
		Элементы.СоздатьОбменЧерезСервисЭДО.Видимость = Ложь;
	КонецЕсли;
	
	НастроитьОтображениеГруппыСоздать();
	
	//ОК(СофтЛаб) Вдовиченко Г.В. 20181101 №3103
	ок_УправлениеФормами.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	//ОК(СофтЛаб) Вдовиченко Г.В. 20181101 №3103
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "СозданПрофиль1СЭДО"
		Или ИмяСобытия = "ОбновленСписокУчетныхЗаписей1СЭДО" Тогда
		Элементы.Список.Обновить();
	ИначеЕсли ИмяСобытия = "Запись_НаборКонстант"
		И Источник = "ИспользоватьПрямойОбменЭлектроннымиДокументами" Тогда
		ПриИзмененииИспользованияПрямогоОбмена();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьОбменЧерезСервисЭДО(Команда)
	
	ПараметрыФормы = Неопределено;
	Если ЗначениеЗаполнено(ПредопределенныйОтбор) Тогда
		ПараметрыФормы = Новый Структура(ПредопределенныйОтбор);
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.УчетныеЗаписиЭДО.Форма.ПомощникПодключенияЭДО", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПрямойОбмен(Команда)
	
	ПараметрыФормы = Неопределено;
	Если ЗначениеЗаполнено(ПредопределенныйОтбор) Тогда
		ПараметрыФормы = Новый Структура(ПредопределенныйОтбор);
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.УчетныеЗаписиЭДО.Форма.УчетнаяЗаписьПрямогоОбмена", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеСписка()
	
	Список.УсловноеОформление.Элементы.Очистить();
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Предупреждения.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Предупреждения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Предупреждения.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Предупреждения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Отсутствуют>'"));
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОператорЭДО.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЭтоПрямойОбмен");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст",
		Новый ПолеКомпоновкиДанных("СпособОбменаПредставление"));
	
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеГруппыСоздать()
	
	Если ОбменСКонтрагентамиСлужебный.ИспользоватьПрямойОбмен() Тогда
		Элементы.ГруппаСоздать.Вид = ВидГруппыФормы.Подменю;
		Элементы.ГруппаСоздать.Картинка = БиблиотекаКартинок.СоздатьЭлементСписка;
		Элементы.СоздатьОбменЧерезСервисЭДО.Заголовок = НСтр("ru = 'через сервис ЭДО'");
		Элементы.СоздатьОбменЧерезСервисЭДО.Картинка = БиблиотекаКартинок.Пустая;
	Иначе
		Элементы.ГруппаСоздать.Вид = ВидГруппыФормы.ГруппаКнопок;
		Элементы.СоздатьОбменЧерезСервисЭДО.Заголовок = НСтр("ru = 'Создать'");
		Элементы.СоздатьОбменЧерезСервисЭДО.Картинка = БиблиотекаКартинок.СоздатьЭлементСписка;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииИспользованияПрямогоОбмена()
	
	Список.Параметры.УстановитьЗначениеПараметра("ИспользоватьПрямойОбмен",
		ОбменСКонтрагентамиСлужебный.ИспользоватьПрямойОбмен());
	
	НастроитьОтображениеГруппыСоздать();
	
КонецПроцедуры

#КонецОбласти

//ОК(СофтЛаб) Вдовиченко Г.В. 20181101 №3103

#Область ок_Доработки

&НаКлиенте
Процедура ок_ВыполнитьКоманду(Команда)
	
	ок_УправлениеФормамиКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

//ОК(СофтЛаб) Вдовиченко Г.В. 20181101 №3103
