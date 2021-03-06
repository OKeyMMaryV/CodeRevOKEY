
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УправлениеЭлементамиФормыКлиент();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НуженПинКодПриИзменении(Элемент)
	УправлениеЭлементамиФормыКлиент();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПроверить(Команда)
	ПроверитьТокен(Объект.Токен);
КонецПроцедуры

&НаКлиенте
Процедура КомандаНайтиЧаты(Команда)
	
	РезДанные = НайтиЧаты(Объект.Токен);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Бот", Объект.Ссылка);
	ОткрытьФорму("Справочник.бит_БотыTelegram.Форма.ФормаСозданияЧатов", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПрокси(Команда)
	
	ОткрытьФорму("ОбщаяФорма.бит_НастройкиПроксиТелеграм");

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УправлениеЭлементамиФормыКлиент()

	Элементы.ПинКод.Доступность = Объект.НуженПинКод;
	
КонецПроцедуры // УправлениеЭлементамиФормы()

// Процедура выполняет проверку токена.
//
&НаСервереБезКонтекста
Процедура ПроверитьТокен(Токен)
	
	РезультатПроверки = Справочники.бит_БотыTelegram.ПроверитьТокен(Токен);
	
	Если РезультатПроверки.Существует Тогда
		
		ТекстСообщения =  НСтр("ru = 'Проверка выполнена успешно.'");
		
	Иначе	
		
		ТекстСообщения =  НСтр("ru = 'Ошибка выполнения проверки. %1.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", РезультатПроверки.Сообщение);
		
	КонецЕсли; 
	
	бит_ТелеграмКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры // ПроверитьТокен()

// Функция выполняет поиск чатов с данным ботом.
//
// Возвращаемое значение:
//  РезДанные - Структура.
//
&НаСервереБезКонтекста
Функция НайтиЧаты(Токен)

	РезДанные = Справочники.бит_БотыTelegram.НайтиЧаты(Токен);

	Возврат РезДанные;
	
КонецФункции // НайтиЧаты()

#КонецОбласти
