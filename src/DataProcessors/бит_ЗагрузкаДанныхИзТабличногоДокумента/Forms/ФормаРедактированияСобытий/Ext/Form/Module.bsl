
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

    Объект.РежимЗагрузки = Параметры.РежимЗагрузки;
    
    Объект.СобытиеПередЗаписью          = Параметры.СобытиеПередЗаписью;
    Объект.СобытиеПриЗаписи             = Параметры.СобытиеПриЗаписи;
    Объект.СобытиеПослеДобавленияСтроки = Параметры.СобытиеПослеДобавленияСтроки;
    
    Если Объект.РежимЗагрузки <> "РегистрСведений" Тогда
		Элементы.СтраницаПередЗаписью.Заголовок = НСтр("ru = 'Перед записью объекта'");
		Элементы.СтраницаПриЗаписи.Заголовок    = НСтр("ru = 'При записи объекта'");
	КонецЕсли;
    
    Элементы.ИнформацияПередЗаписьюСправочник.Видимость = Объект.РежимЗагрузки = "Справочник";
    Элементы.ИнформацияПриЗаписиСправочник.Видимость    = Объект.РежимЗагрузки = "Справочник";
    
    Элементы.ИнформацияПередЗаписьюРегистрСведений.Видимость = Объект.РежимЗагрузки = "РегистрСведений";
    Элементы.ИнформацияПриЗаписиРегистрСведений.Видимость    = Объект.РежимЗагрузки = "РегистрСведений";
    
    Элементы.ИнформацияПередЗаписьюТабличнаяЧасть.Видимость          = Объект.РежимЗагрузки = "ТабличнаяЧасть";
    Элементы.ИнформацияПриЗаписиТабличнаяЧасть.Видимость             = Объект.РежимЗагрузки = "ТабличнаяЧасть";
    Элементы.ИнформацияПослеДобавленияСтрокиТабличнаяЧасть.Видимость = Объект.РежимЗагрузки = "ТабличнаяЧасть";
    
	Элементы.СтраницаПослеДобавленияСтроки.Видимость = Объект.РежимЗагрузки = "ТабличнаяЧасть";
        
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Кнопка)
    
    СтруктураСобытий = Новый Структура;
    СтруктураСобытий.Вставить("СобытиеПередЗаписью"         , Объект.СобытиеПередЗаписью);
    СтруктураСобытий.Вставить("СобытиеПриЗаписи"            , Объект.СобытиеПриЗаписи);
    СтруктураСобытий.Вставить("СобытиеПослеДобавленияСтроки", Объект.СобытиеПослеДобавленияСтроки);
    
    Закрыть(СтруктураСобытий);
    
КонецПроцедуры // ОК()

&НаКлиенте
Процедура Отмена(Команда)
    
    Закрыть();
    
КонецПроцедуры // Отмена()

#КонецОбласти
