﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьРазделениеПоОбластямДанных = ИнтеграцияПодсистемБТС.РазделениеВключено()
		И ИнтеграцияПодсистемБТС.ДоступноИспользованиеРазделенныхДанных();
	// бит_Финанс изменение кода. Начало. 26.02.2014{{
	флДоступенРусский = РегистрыСведений.бит_ДоступныеИнтерфейсы.ОпределитьДоступностьРусскогоИнтерфейса();
	Если НЕ флДоступенРусский Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	// бит_Финанс изменение кода. Конец. 26.02.2014}}
	
	
	СсылкаПоискаИнформации = "http://its.1c.ru/db/alldb#search:";
	
	Если ИспользоватьРазделениеПоОбластямДанных Тогда // для модели сервиса
		
		ЗаполнитьДомашнююСтраницу();
		
		ИнформационныйЦентрСерверПереопределяемый.ОпределитьСсылкуПоискаИнформации(СсылкаПоискаИнформации);
		
		СформироватьСписокНовостей();
		
		Элементы.ГруппаСозданияСообщенияВТехподдержку.Видимость = ИнформационныйЦентрСервер.УстановленаИнтеграцияСоСлужбойПоддержки();
		
	Иначе // для локального режима
		
		Элементы.ГруппаСтартовыхСтраниц.Видимость    = Ложь;
		Элементы.ГруппаВзаимодействия.Видимость      = Ложь;
		
	КонецЕсли;
	
	ИнформационныйЦентрСервер.ВывестиКонтекстныеСсылки(ЭтотОбъект, Элементы.ИнформационныеСсылки, 1, 10, Ложь);
	
	ЕстьПравоДоступаКБухфону = ПравоДоступа("Просмотр", Метаданные.ОбщиеКоманды.СвязатьсяСоСпециалистомОнлайнПоддержки);
	
	НайденныйЭлемент = Элементы.Найти("ОбщаяКомандаЗапустить1СБухфон");
	Если ЕстьПравоДоступаКБухфону И НайденныйЭлемент <> Неопределено Тогда
		ИнтеграцияПодсистемБТС.ИнтеграцияВызовОнлайнПоддержкиПриСозданииНаСервере(НайденныйЭлемент);
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользованиеКаталогаРасширенийВМоделиСервиса") Тогда
		Элементы.ГруппаКаталогРасширений.Видимость = Истина;
	Иначе
		Элементы.ГруппаКаталогРасширений.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ЕстьПравоДоступаКБухфону Тогда
		ИнтеграцияПодсистемБТСКлиент.ИнтеграцияВызовОнлайнПоддержкиКлиентОбработкаОповещения(ИмяСобытия, Элементы.ОбщаяКомандаЗапустить1СБухфон);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы


// Параметры:
// 	Элемент - ДекорацияФормы - элемент формы описания новости.
&НаКлиенте
Процедура Подключаемый_НажатиеНаНовость(Элемент)
	
	Фильтр = Новый Структура;
	Фильтр.Вставить("ИмяЭлементаФормы", Элемент.Имя);
	
	МассивСтрок = ТаблицаНовостей.НайтиСтроки(Фильтр);
	Если МассивСтрок.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	ТекущееСообщение = МассивСтрок.Получить(0); // ДанныеФормыЭлементКоллекции
	ИдентификаторСообщения = ТекущееСообщение.Идентификатор;
	
	Если ТекущееСообщение.ТипИнформации = "Недоступность" Тогда 
		
		ВнешняяСсылка = ТекущееСообщение.ВнешняяСсылка;
		
		Если Не ПустаяСтрока(ВнешняяСсылка) Тогда 
			ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(ВнешняяСсылка);
			Возврат;
		КонецЕсли;
		
		ИнформационныйЦентрКлиент.ПоказатьНовость(ИдентификаторСообщения);
		
	ИначеЕсли ТекущееСообщение.ТипИнформации = "УведомлениеОПожелании" Тогда 
		
		ИдентификаторИдеи = Строка(ИдентификаторСообщения);
		
		ИнформационныйЦентрКлиент.ПоказатьИдею(ИдентификаторИдеи);
		
    ИначеЕсли ТекущееСообщение.ТипИнформации = "Новость" Тогда
        
		ИнформационныйЦентрКлиент.ПоказатьНовость(ИдентификаторСообщения);
        
    КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеЕщеСообщения(Элемент)
	
	ИнформационныйЦентрКлиент.ПоказатьВсеСообщения();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбращенияВПоддержкуНажатие(Элемент)
	
	ИнформационныйЦентрКлиент.ОткрытьОбращенияВСлужбуПоддержки();
	
КонецПроцедуры

&НаКлиенте
Процедура ЦентрИдейНажатие(Элемент)
	
	ИнформационныйЦентрКлиент.ОткрытьЦентрИдей();
	
КонецПроцедуры

&НаКлиенте
Процедура ДомашняяСтраницаНажатие(Элемент)
	
	Если Не ДомашняяСтраница.Свойство("URL") Тогда 
		Возврат;
	КонецЕсли;
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(ДомашняяСтраница.URL);
	
КонецПроцедуры

&НаКлиенте
Процедура ФорумНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.ОбсужденияНаФоруме");
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогРасширенийНажатие(Элемент)
	
	ОткрытьФорму("Обработка.КаталогРасширений.Форма");
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиОтветНаВопрос(Команда)
	
	ПоискОтветаНаВопрос();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеНаИнформационнуюСсылку(Команда) Экспорт
	
	ИнформационныйЦентрКлиент.НажатиеНаИнформационнуюСсылку(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДомашнююСтраницу()
	
	URL = ПолучитьНавигационнуюСсылкуИнформационнойБазы();
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
	
	Если Не ПустаяСтрока(СтруктураURI.Хост) Тогда
		ДомашняяСтраница = Новый Структура("Хост, URL", СтруктураURI.Хост, СтруктураURI.Схема + "://" + СтруктураURI.Хост);
		Элементы.ДомашняяСтраница.Заголовок = ДомашняяСтраница.Хост;
	Иначе
		Элементы.ДомашняяСтраница.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСписокНовостей()
	
	ИнформационныйЦентрСервер.СформироватьСписокНовостейНаРабочийСтол(ТаблицаНовостей);
	
	Если ТаблицаНовостей.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	ГруппаНовостей = Элементы.ГруппаНовостей;
	
	Для Итерация = 0 По ТаблицаНовостей.Количество() - 1 Цикл
		
		Наименование = ТаблицаНовостей.Получить(Итерация).СсылкаНаДанные.Наименование;
		
		Если ПустаяСтрока(Наименование) Тогда 
			Продолжить;
		КонецЕсли;
		
		Критичность  = ТаблицаНовостей.Получить(Итерация).СсылкаНаДанные.Критичность;
		Картинка     = ?(Критичность > 5, БиблиотекаКартинок.УведомлениеСервиса, БиблиотекаКартинок.СообщениеСервиса);
		
		ГруппаНовости                     = Элементы.Добавить("ГруппаНовости" + Строка(Итерация), Тип("ГруппаФормы"), ГруппаНовостей);
		ГруппаНовости.Вид                 = ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаНовости.ОтображатьЗаголовок = Ложь;
		ГруппаНовости.Группировка         = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		ГруппаНовости.Отображение         = ОтображениеОбычнойГруппы.Нет;
		
		КартинкаНовости                = Элементы.Добавить("КартинкаНовости" + Строка(Итерация), Тип("ДекорацияФормы"), ГруппаНовости);
		КартинкаНовости.Вид            = ВидДекорацииФормы.Картинка;
		КартинкаНовости.Картинка       = Картинка;
		КартинкаНовости.Ширина         = 2;
		КартинкаНовости.Высота         = 1;
		КартинкаНовости.РазмерКартинки = РазмерКартинки.Растянуть;
		
		ИмяНовости                          = Элементы.Добавить("ИмяНовости" + Строка(Итерация), Тип("ДекорацияФормы"), ГруппаНовости);	
		ИмяНовости.Вид                      = ВидДекорацииФормы.Надпись;
		ИмяНовости.Заголовок                = Наименование;
		ИмяНовости.РастягиватьПоГоризонтали = Истина;
		ИмяНовости.ВертикальноеПоложение    = ВертикальноеПоложениеЭлемента.Центр;
		ИмяНовости.ВысотаЗаголовка          = 1;
		Обработки.ИнформационныйЦентр.УстановитьПризнакГиперссылки(ИмяНовости);
		ИмяНовости.УстановитьДействие("Нажатие", "Подключаемый_НажатиеНаНовость");
		
		ТаблицаНовостей.Получить(Итерация).ИмяЭлементаФормы = ИмяНовости.Имя;
		ТаблицаНовостей.Получить(Итерация).ТипИнформации    = ТаблицаНовостей.Получить(Итерация).СсылкаНаДанные.ТипИнформации.Наименование;
		ТаблицаНовостей.Получить(Итерация).Идентификатор    = ТаблицаНовостей.Получить(Итерация).СсылкаНаДанные.Идентификатор;
		ТаблицаНовостей.Получить(Итерация).ВнешняяСсылка    = ТаблицаНовостей.Получить(Итерация).СсылкаНаДанные.ВнешняяСсылка;
		
	КонецЦикла;
	
	ЕщеСообщения                          = Элементы.Добавить("ЕщеСообщения", Тип("ДекорацияФормы"), ГруппаНовостей);
	ЕщеСообщения.Вид                      = ВидДекорацииФормы.Надпись;
	ЕщеСообщения.Заголовок                = НСтр("ru = 'Еще сообщения'");
	ЕщеСообщения.РастягиватьПоГоризонтали = Истина;
	ЕщеСообщения.ВертикальноеПоложение    = ВертикальноеПоложениеЭлемента.Центр;
	Обработки.ИнформационныйЦентр.УстановитьПризнакГиперссылки(ЕщеСообщения);
	ЕщеСообщения.УстановитьДействие("Нажатие", "Подключаемый_НажатиеЕщеСообщения");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискОтветаНаВопрос()
	
	ПодключитьОбработчикОжидания("ОбработкаОжиданияПоискаОтветаНаВопрос", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОжиданияПоискаОтветаНаВопрос()
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		Возврат;
	КонецЕсли;
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(СсылкаПоискаИнформации + СтрокаПоиска);
	
КонецПроцедуры

#КонецОбласти