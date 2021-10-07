﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "СтатистикаПоПоказателям"
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Процедура ЭкспортНакопленнойСтатистики() Экспорт
	
	// В случае отсутствующего или устаревшего значения границы статистики ограничиваем передачу старой 
	// информации началом дня
	Если НачалоДня(Константы.НижняяГраницаСчитыванияСтатистики.Получить()) < НачалоДня(ТекущаяДата()) Тогда
		Константы.НижняяГраницаСчитыванияСтатистики.Установить(НачалоДня(ТекущаяДата()));
	КонецЕсли;
	
	НачалоПрошлогоЧаса = НачалоЧаса(НачалоЧаса(ТекущаяДата()) - 1);
	
	Если Константы.НижняяГраницаСчитыванияСтатистики.Получить() > НачалоПрошлогоЧаса Тогда
		//данные за прошлый час уже переданы, повторная передача не требуется
		Возврат;
	Иначе
		НижняяГраница = НачалоЧаса(Константы.НижняяГраницаСчитыванияСтатистики.Получить());
		ВерхняяГраница = КонецЧаса(НижняяГраница);
	КонецЕсли;
	
	// Извлечение данных статистики
	ОтборИнформация = Новый Структура("ДатаНачала, ДатаОкончания, Уровень, Событие",
		НижняяГраница, ВерхняяГраница, УровеньЖурналаРегистрации.Информация, СтатистикаПоПоказателямКлиентСервер.МаркерСобытияСтатистики());
		
	ЖурналРегистрацииИнформация = Новый ТаблицаЗначений;
	ВыгрузитьЖурналРегистрации(ЖурналРегистрацииИнформация, ОтборИнформация);
	
	ТаблицаДляОтправки = ПодготовитьТаблицуДляОтправки(ЖурналРегистрацииИнформация);
	
	ОтправитьСтатистику(ТаблицаДляОтправки, ВерхняяГраница);
	Константы.НижняяГраницаСчитыванияСтатистики.Установить(ВерхняяГраница + 1);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПодготовитьТаблицуДляОтправки(ЖурналРегистрацииИнформация)
	
	МаксЧислоСчетчиковВПакете = 1000;
	ОграничениеДлиныКомментария = 300;
	
	ТаблицаИнформация = Новый ТаблицаЗначений;
	ТаблицаИнформация.Колонки.Добавить("Событие", Новый ОписаниеТипов("Строка"));
	ТаблицаИнформация.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	ТаблицаИнформация.Колонки.Добавить("ОбластьДанных", Новый ОписаниеТипов("Число,Строка"));
	ТаблицаИнформация.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	ТаблицаИнформация.Колонки.Добавить("Комментарий", Новый ОписаниеТипов("Строка"));
	
	ЕстьРазделитель = ЖурналРегистрацииИнформация.Колонки.Найти("РазделениеДанныхСеанса") <> Неопределено;
	МаркерСобытияСтатистики = СтатистикаПоПоказателямКлиентСервер.МаркерСобытияСтатистики();
	Для Каждого СтрокаТаблицы Из ЖурналРегистрацииИнформация Цикл	
		Если СтрНайти(СтрокаТаблицы.Событие, МаркерСобытияСтатистики) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ИндексМаркера = Найти(СтрокаТаблицы.Комментарий, МаркерСобытияСтатистики);
		СтрокаСМаркером = СтрПолучитьСтроку(СтрокаТаблицы.Комментарий, 1);
		Событие = СокрЛП(СтрЗаменить(Сред(СтрокаСМаркером, ИндексМаркера), МаркерСобытияСтатистики + ".", ""));
		
		Комментарий = СтрПолучитьСтроку(СтрокаТаблицы.Комментарий, 2);
		ЧастиКомментария = РазделитьСтрокуНаЧасти(Комментарий, ОграничениеДлиныКомментария);
		Если ЧастиКомментария.Количество() = 0 Тогда
			ЧастиКомментария.Добавить("");
		КонецЕсли;
		
		Для Индекс = 0 По ЧастиКомментария.Количество() - 1 Цикл
			НоваяСтрока = ТаблицаИнформация.Добавить();
			
			НоваяСтрока.Событие = Событие;
			НоваяСтрока.Комментарий = ЧастиКомментария[Индекс];
			НоваяСтрока.Количество = 1;
			Если ЕстьРазделитель И СтрокаТаблицы.РазделениеДанныхСеанса.Свойство("ОбластьДанныхОсновныеДанные") Тогда
				НоваяСтрока.ОбластьДанных = СтрокаТаблицы.РазделениеДанныхСеанса.ОбластьДанныхОсновныеДанные;
			КонецЕсли;
			
			НоваяСтрока.Период = НачалоМинуты(СтрокаТаблицы.Дата);
		КонецЦикла;
	КонецЦикла;
	
	ТаблицаИнформация.Свернуть("Событие, Комментарий, ОбластьДанных, Период", "Количество");
	
	// Передаем только наиболее часто встречающиеся 1000 счетчиков за час
	ТОПТаблица = ТаблицаИнформация.Скопировать(, "Событие,Количество");
	ТОПТаблица.Свернуть("Событие","Количество");
	ТОПТаблица.Сортировать("Количество Убыв");
	ТОП = Новый Соответствие();
	Для Сч = 0 По Мин(МаксЧислоСчетчиковВПакете - 1, ТОПТаблица.Количество() - 1) Цикл
		ТОП[ТОПТаблица[Сч].Событие] = 1;
	КонецЦикла;
	ИндексЗаписи = ТаблицаИнформация.Количество() - 1;
	Пока ИндексЗаписи >= 0 Цикл
		Если ТОП[ТаблицаИнформация[ИндексЗаписи].Событие] = Неопределено Тогда
			ТаблицаИнформация.Удалить(ИндексЗаписи);
		КонецЕсли;
		ИндексЗаписи = ИндексЗаписи - 1;
	КонецЦикла;
	
	Возврат ТаблицаИнформация;
	
КонецФункции

Процедура ОтправитьСтатистику(Знач КоллекцияСведений, ВерхняяГраница)
	
	ИмяФайлаСтатистики = ПолучитьИмяВременногоФайла(".txt");
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайлаСтатистики);
	
	Для Каждого СтрокаТаблицы Из КоллекцияСведений Цикл
		СтрокаДляЗаписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"%1#%2#%3#%4#%5", XMLСтрока(СтрокаТаблицы.Период), XMLСтрока(СтрокаТаблицы.ОбластьДанных),
			СтрокаТаблицы.Событие, XMLСтрока(СтрокаТаблицы.Количество), XMLСтрока(СтрокаТаблицы.Комментарий));
			
		ЗаписьТекста.ЗаписатьСтроку(СтрокаДляЗаписи);
	КонецЦикла;
	
	ЗаписьТекста.Закрыть();
	
	ИмяАрхива = ПолучитьИмяВременногоФайла(".zip");
	
	ЗаписьZip = Новый ЗаписьZipФайла(ИмяАрхива,,,, УровеньСжатияZIP.Максимальный);
	ЗаписьZip.Добавить(ИмяФайлаСтатистики);
	ЗаписьZip.Записать();
	
	Попытка
		ИдентификаторФайла = РаботаВМоделиСервиса.ПоместитьФайлВХранилищеМенеджераСервиса(Новый ДвоичныеДанные(ИмяАрхива));
	Исключение
		УдалитьФайлы(ИмяФайлаСтатистики);
		УдалитьФайлы(ИмяАрхива);	
		ВызватьИсключение;
	КонецПопытки;
	
	УдалитьФайлы(ИмяФайлаСтатистики);
	УдалитьФайлы(ИмяАрхива);
	
	НачатьТранзакцию();
	
	Попытка
		
		Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияСтатистикаПоПоказателямИнтерфейс.СообщениеСведение());
		
		Тело = Сообщение.Body;
		Тело.FileId = ИдентификаторФайла;
		Тело.Period = КонецЧаса(ВерхняяГраница);
		
		СообщенияВМоделиСервиса.ОтправитьСообщение(
			Сообщение,
			РаботаВМоделиСервисаПовтИсп.КонечнаяТочкаМенеджераСервиса());
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

Функция РазделитьСтрокуНаЧасти(Знач ИсходнаяСтрока, ОграничениеДлиныПорции)
	
	Результат = Новый Массив;
	
	Если ПустаяСтрока(ИсходнаяСтрока)
		Или СтрДлина(ИсходнаяСтрока) <= ОграничениеДлиныПорции Тогда
		Результат.Добавить(ИсходнаяСтрока);
		Возврат Результат;
	КонецЕсли;
	
	ХешСтроки = ОбщегоНазначения.КонтрольнаяСуммаСтрокой(ИсходнаяСтрока, ХешФункция.MD5);
	
	НомерИтерации = 0;
	Пока Не ПустаяСтрока(ИсходнаяСтрока) Цикл
		
		ПрефиксЧастиСтроки = СтрШаблон("%1_%2_", ХешСтроки, Формат(НомерИтерации, "ЧН=0; ЧГ=0"));
		
		ДлинаЧастиСтроки = ОграничениеДлиныПорции - СтрДлина(ПрефиксЧастиСтроки);
		
		ЧастьСтроки = Лев(ИсходнаяСтрока, ДлинаЧастиСтроки);
		
		ИсходнаяСтрока = Сред(ИсходнаяСтрока, ДлинаЧастиСтроки + 1);
		НомерИтерации = НомерИтерации + 1;
		
		Результат.Добавить(СтрШаблон("%1%2", ПрефиксЧастиСтроки, ЧастьСтроки));
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти