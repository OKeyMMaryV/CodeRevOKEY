
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события "ПриСозданииНаСервере" формы.
// 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Периодичность = Параметры.Периодичность;
	
	Для Каждого ТекущийЭлементМассива Из Параметры.Сценарии Цикл
		НоваяСтрока = Сценарии.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущийЭлементМассива);
	КонецЦикла;
	
	мКэшЗначений = Новый Структура;
	СтруктураПеречислений = Новый Структура;
	СтруктураПеречислений.Вставить("бит_ПериодичностьПланирования", бит_ОбщегоНазначения.КэшироватьЗначенияПеречисления(Перечисления.бит_ПериодичностьПланирования));
	мКэшЗначений.Вставить("Перечисления", СтруктураПеречислений);
	
	// Макет нужен только для того, чтобы не было видно области легенды, ибо ее можно скрыть только в макете.
	Макет = Отчеты.бит_СценарноеПрогнозирование.ПолучитьМакет("МакетДиаграммаГанта");
	ИнтервалыОтчета = Макет.Рисунки.D3.Объект;
	
	ПостроитьОтображениеПериода(ИнтервалыОтчета, Сценарии);
	
КонецПроцедуры

// Процедура - обработчик события "ПриОткрытии" формы.
// 
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Настроим отображение шкалы времени
	НастроитьШкалуВремени();
	
КонецПроцедуры

// Процедура - обработчик события "ОбработкаВыбора" формы.
// 
&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НоваяСтрока = Сценарии.Добавить();
	НоваяСтрока.Сценарий = ВыбранноеЗначение;
	
	ПостроитьОтображениеПериода(ИнтервалыОтчета, Сценарии);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события "ПриОкончанииРедактированияИнтервала" диаграммы Ганта "ИнтервалыОтчета".
// 
&НаКлиенте
Процедура ИнтервалыОтчетаПриОкончанииРедактированияИнтервала(Элемент, Интервал, ОтменаРедактирования)
	
	// Сгладить погрешности интерактивного перетаскивания - 
	
	// Округлить интервал по периодичности 
	ЗначениеПериодичности = ПолучитьЗначениеПеречисленияПериодичность(Периодичность);
	
	// Обрабатываем дату начала интервала
	
	// Определяем границы периода в который попала дата начала.
	НачалоПериода = бит_Бюджетирование.ПолучитьНачалоПериода(Интервал.Начало, ЗначениеПериодичности);
	КонецПериода  = бит_Бюджетирование.ПолучитьКонецПериода(Интервал.Начало, ЗначениеПериодичности);
	
	// Определим к какой границе дата начала находится ближе.
	РазностьНачало = бит_Бюджетирование.РазностьДат(НачалоПериода, Интервал.Начало, "ДЕНЬ");
	РазностьКонец  = бит_Бюджетирование.РазностьДат(Интервал.Начало, КонецПериода, "ДЕНЬ");
	
	// Приведем дату начала к ближайшей границе периода.
	Если РазностьНачало <= РазностьКонец Тогда
		Интервал.Начало = НачалоДня(НачалоПериода);
	Иначе
		Интервал.Начало = НачалоДня(КонецПериода);
	КонецЕсли;
	
	// Обрабатываем дату конца интервала
	
	// Определяем границы периода в который попала дата конца.
	НачалоПериода = бит_Бюджетирование.ПолучитьНачалоПериода(Интервал.Конец, ЗначениеПериодичности);
	КонецПериода  = бит_Бюджетирование.ПолучитьКонецПериода(Интервал.Конец, ЗначениеПериодичности);
	
	// Определим к какой границе дата конца находится ближе.
	РазностьНачало = бит_Бюджетирование.РазностьДат(НачалоПериода, Интервал.Конец, "ДЕНЬ");
	РазностьКонец  = бит_Бюджетирование.РазностьДат(Интервал.Конец, КонецПериода, "ДЕНЬ");
	
	// Приведем дату конца к ближайшей границе периода.
	Если РазностьНачало <= РазностьКонец Тогда
		Интервал.Конец = КонецДня(НачалоПериода);
	Иначе
		Интервал.Конец = КонецДня(КонецПериода);
	КонецЕсли;
	
	ИзменяемыйСценарий = Интервал.Значение.Точка.Значение;
	
	// Обновим период в таб.части
	СтрокаСценария = Сценарии[Интервал.Расшифровка];
	
	СтрокаСценария.ДатаНачала 	 = Интервал.Начало;
	СтрокаСценария.ДатаОкончания = Интервал.Конец;
	
	ПостроитьОтображениеПериода(ИнтервалыОтчета, Сценарии);
	
КонецПроцедуры

// Процедура - обработчик события "Выбор" поля диаграммы Ганта "ИнтервалыОтчета".
// 
&НаКлиенте
Процедура ИнтервалыОтчетаВыбор(Элемент, Значения, СтандартнаяОбработка, Дата)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ТипЗнч(Значения) = Тип("Массив") Тогда
		СписокДействий = Новый СписокЗначений;
		
		Если ТипЗнч(Значения) = Тип("ТочкаДиаграммыГанта") Тогда
			ВыбраннаяТочка = Значения;
		Иначе
			ВыбраннаяТочка = Значения.Точка;
		КонецЕсли;
		
		СписокДействий.Добавить("ОткрытьЭлемент", "Открыть элемент """ + ВыбраннаяТочка.Значение + """");
		СписокДействий.Добавить("УстановитьПериод", "Установить период для элемента """ + ВыбраннаяТочка.Значение + """");
		СписокДействий.Добавить("УдалитьЭлемент", "Удалить элемент """ + ВыбраннаяТочка.Значение + """");
		
		ДопПараметры = Новый Структура("ВыбраннаяТочка", ВыбраннаяТочка);
		ОбработчикВД = Новый ОписаниеОповещения("ОбработчикВыбораДействияЗавершение", ЭтаФорма, ДопПараметры);
		СписокДействий.ПоказатьВыборЭлемента(ОбработчикВД, "Укажите необходимое действие");
				
	Иначе
		
		Для Каждого ТекущийЭлементМассива Из Значения Цикл
			
			Если ТипЗнч(ТекущийЭлементМассива) = Тип("ИнтервалДиаграммыГанта") Тогда
				
				ТекущиеДанные = Сценарии[ТекущийЭлементМассива.Расшифровка];   				
				УстановитьПериодИнтервала(ТекущиеДанные); 				
				//ПостроитьОтображениеПериода(ИнтервалыОтчета, Сценарии);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // ИнтервалыОтчетаВыбор()

// Процедура обработчик оповещения "ОбработчикВыбораДействияЗавершение".
// 
// Параметры:
// ВыбранноеДействие - Структура.
// ДопПараметры - Структура.
// 
&НаКлиенте
Процедура ОбработчикВыбораДействияЗавершение(ВыбранноеДействие, ДопПараметры) Экспорт
	
	Если ВыбранноеДействие = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыбраннаяТочка = ДопПараметры.ВыбраннаяТочка;
	
	Если ВыбранноеДействие.Значение = "ОткрытьЭлемент" Тогда
		ПоказатьЗначение( , ВыбраннаяТочка.Значение);
	ИначеЕсли ВыбранноеДействие.Значение = "УстановитьПериод" Тогда
		ТекущиеДанные = Сценарии[ВыбраннаяТочка.Расшифровка];  			
		УстановитьПериодИнтервала(ТекущиеДанные);     			
		//ПостроитьОтображениеПериода(ИнтервалыОтчета, Сценарии);
	ИначеЕсли ВыбранноеДействие.Значение = "УдалитьЭлемент" Тогда
		Сценарии.Удалить(Сценарии[ВыбраннаяТочка.Расшифровка]); 			
		ПостроитьОтображениеПериода(ИнтервалыОтчета, Сценарии);
	КонецЕсли;	  
	
КонецПроцедуры // ОбработчикВыбораДействияЗавершение()

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - действие команды "ПрименитьИЗакрыть".
// 
&НаКлиенте
Процедура ПрименитьИЗакрыть(Команда)
	
	СтруктураНастроек = Новый Структура;
	
	СтруктураТочек = Новый Массив;
	
	Для Каждого ТекущаяСтрока Из Сценарии Цикл
		СтруктураЗначенийСерии = Новый Структура;
		СтруктураЗначенийСерии.Вставить("Сценарий"		, ТекущаяСтрока.Сценарий);
		СтруктураЗначенийСерии.Вставить("ДатаНачала"	, ТекущаяСтрока.ДатаНачала);
		СтруктураЗначенийСерии.Вставить("ДатаОкончания"	, ТекущаяСтрока.ДатаОкончания);
		
		СтруктураТочек.Добавить(СтруктураЗначенийСерии);
	КонецЦикла;
	
	СтруктураНастроек.Вставить("Сценарии", СтруктураТочек);
	
	Закрыть(СтруктураНастроек);
	
КонецПроцедуры

// Процедура - действие команды "КомандаЗакрыть".
// 
&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

// Процедура - действие команды "КомандаДобавитьСценарий".
// 
&НаКлиенте
Процедура КомандаДобавитьСценарий(Команда)
	
	ИмяСправочникаСценарии = бит_ОбщегоНазначения.ПолучитьИмяСправочникаСценарииБюджетирования();
	
	ОткрытьФорму("Справочник." + ИмяСправочникаСценарии + ".ФормаВыбора"
					, , ЭтаФорма, , , , , РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура формирует диаграмму Ганта.
// 
&НаКлиентеНаСервереБезКонтекста
Процедура ПостроитьОтображениеПериода(пИнтервалыОтчета, пСценарии)
	
	ДГ = пИнтервалыОтчета; 
	
	ДГ.Очистить();
	
	ДГ.Обновление = Ложь;
	
	ДГ.ОтображатьЗаголовок = Ложь;
	ДГ.ОтображатьЛегенду   = Ложь;
	
	ДГ.ОбластьЛегенды.ПрозрачныйФон = Истина;
	
	// Установить заголовок диаграммы. 
	// ДГ.ОбластьЗаголовка.Текст = "Период сбора данных"; 
	
	// Интервал будем определять самостоятельно. 
	ДГ.АвтоОпределениеПолногоИнтервала = Ложь;
	
	СписокДат = Новый СписокЗначений;
	
	Для Каждого ТекущаяСтрока Из пСценарии Цикл
		СписокДат.Добавить(ТекущаяСтрока.ДатаНачала);
		СписокДат.Добавить(ТекущаяСтрока.ДатаОкончания);
	КонецЦикла;
	
	СписокДат.СортироватьПоЗначению();
	
	МинимальнаяДата  = ?(СписокДат.Количество()=0, ТекущаяДата(), СписокДат[0].Значение);
	МаксимальнаяДата = ?(СписокДат.Количество()=0, ТекущаяДата(), СписокДат[СписокДат.Количество()-1].Значение);
	
	// Минимальная дата не установлена, но установлена максимальная дата.
	Если МинимальнаяДата <= Дата(1000,01,01)
		И МаксимальнаяДата > Дата(1000,01,01)
		И МаксимальнаяДата < Дата(3000,01,01) Тогда
		МинимальнаяДата = Дата(1980,01,01);
	// Даты не заполнены
	ИначеЕсли МинимальнаяДата <= Дата(1000,01,01)
		И МаксимальнаяДата <= Дата(1000,01,01) Тогда
		МинимальнаяДата  = ТекущаяДата();
		МаксимальнаяДата = ТекущаяДата();
	КонецЕсли;
	
	ДГ.УстановитьПолныйИнтервал(НачалоГода(МинимальнаяДата), КонецГода(МаксимальнаяДата));
	
	// Установить интервал. 
	// ДГ.УстановитьПолныйИнтервал(Отчет.ПериодСценарий1.ДатаНачала, Отчет.ПериодСценарий2.ДатаОкончания); 
	
	ДГ.ПоддержкаМасштаба = ПоддержкаМасштабаДиаграммыГанта.Авто;
	
	// 1 серия 
	Серия = ДГ.УстановитьСерию("Период"); 
	Серия.ШтриховкаПерекрывающихсяИнтервалов = Истина;
	
	// Задать цвета серий, отличные от цвета по умолчанию. 
	Серия.Цвет = WebЦвета.Синий;
	
	// Определим в диаграмме точки
	НомерСтроки = 0;
	
	Для Каждого ТекущаяСтрока Из пСценарии Цикл
		Точка = ДГ.УстановитьТочку(ТекущаяСтрока.Сценарий);
		Точка.Расшифровка = НомерСтроки;
		
		// Получить значение диаграммы 
		Значение = ДГ.ПолучитьЗначение(Точка, Серия); 
		
		Значение.Редактирование 	= Истина;
		Значение.ДополнительныйЦвет = WebЦвета.ЖелтоЗеленый;
		
		// В значении определить новый интервал 
		ИнтервалЗначения = Значение.Добавить();
		
		ИнтервалЗначения.Текст 		 = "Период";
		// Расшифровка используется при интерактивном изменении интервала, чтобы обновить значение периода в таб.части.
		ИнтервалЗначения.Расшифровка = НомерСтроки;
		
		// Определить границы интервала. 
		ИнтервалЗначения.Начало = ТекущаяСтрока.ДатаНачала; 
		ИнтервалЗначения.Конец  = ТекущаяСтрока.ДатаОкончания;
		
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
	ДГ.Обновление = Истина;
	
КонецПроцедуры

// Процедура настраивает шкалу времени на диаграмме Ганта.
// 
&НаКлиенте
Процедура НастроитьШкалуВремени()
	
	ДГ = ИнтервалыОтчета;
	
	ЗначениеПериодичности = ПолучитьЗначениеПеречисленияПериодичность(Периодичность);
	
	ЭлементыШкалыВремени = ДГ.ОбластьПостроения.ШкалаВремени.Элементы;
	
	Если ЭлементыШкалыВремени.Количество() = 0 Тогда
		ЭлементШкалы = ЭлементыШкалыВремени.Добавить();
	Иначе
		ЭлементШкалы = ЭлементыШкалыВремени[0];
	КонецЕсли;
	
	ЭлементШкалы.Видимость = Истина;
	
	Если ЗначениеПериодичности = мКэшЗначений.Перечисления.бит_ПериодичностьПланирования.Декада
		ИЛИ ЗначениеПериодичности = мКэшЗначений.Перечисления.бит_ПериодичностьПланирования.Полугодие
		ИЛИ ЗначениеПериодичности = мКэшЗначений.Перечисления.бит_ПериодичностьПланирования.Месяц
		ИЛИ ЗначениеПериодичности = мКэшЗначений.Перечисления.бит_ПериодичностьПланирования.Квартал
		ИЛИ ЗначениеПериодичности = мКэшЗначений.Перечисления.бит_ПериодичностьПланирования.Год Тогда
		ЭлементШкалы.Единица = ТипЕдиницыШкалыВремени.Год;
	Иначе
		ЭлементШкалы.Единица = ТипЕдиницыШкалыВремени[Строка(ЗначениеПериодичности)];
	КонецЕсли;
	
	ЭлементШкалы.Кратность = 1;
	ЭлементШкалы.Формат = "ДФ='yyyy'";
	
	Если ЭлементШкалы.Единица = ТипЕдиницыШкалыВремени.Год Тогда
		ЭлементШкалы = ЭлементыШкалыВремени.Добавить();
		ЭлементШкалы.Видимость = Истина;
		ЭлементШкалы.Единица   = ТипЕдиницыШкалыВремени.Месяц;
		ЭлементШкалы.Кратность = 1;
		ЭлементШкалы.Формат	   = "ДФ='MM'";
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗначениеПеречисленияПериодичность(Периодичность, ВозвращатьСтроку=Ложь)
	
	Если Периодичность = 12 Тогда
		ЗначениеПериодичности = Перечисления.бит_ПериодичностьПланирования.Год;
	ИначеЕсли Периодичность = 11 Тогда
		ЗначениеПериодичности = Перечисления.бит_ПериодичностьПланирования.Полугодие;
	ИначеЕсли Периодичность = 10 Тогда
		ЗначениеПериодичности = Перечисления.бит_ПериодичностьПланирования.Квартал;
	ИначеЕсли Периодичность = 9 Тогда
		ЗначениеПериодичности = Перечисления.бит_ПериодичностьПланирования.Месяц;
	ИначеЕсли Периодичность = 8 Тогда
		ЗначениеПериодичности = Перечисления.бит_ПериодичностьПланирования.Декада;
	ИначеЕсли Периодичность = 7 Тогда
		ЗначениеПериодичности = Перечисления.бит_ПериодичностьПланирования.Неделя;
	Иначе
		ЗначениеПериодичности = Перечисления.бит_ПериодичностьПланирования.День; 
	КонецЕсли;
	
	Если ВозвращатьСтроку Тогда
		Возврат Строка(ЗначениеПериодичности);
	Иначе
		Возврат ЗначениеПериодичности;
	КонецЕсли;
	
КонецФункции

// Процедура открывает окно настройки периода.
// 
// Параметры:
// 	Контейнер - СтрокаТаблицыЗначений - источник периода.
// 
&НаКлиенте
Процедура УстановитьПериодИнтервала(Контейнер)
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период.ДатаНачала 	= Контейнер.ДатаНачала;
	Диалог.Период.ДатаОкончания = Контейнер.ДатаОкончания;
	Диалог.Период.Вариант		= ВариантСтандартногоПериода.ПроизвольныйПериод;
		
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("Контейнер", Контейнер);
	
	Оповещение = Новый ОписаниеОповещения("ВыборПериодаПоДатамЗавершение", ЭтотОбъект, ДопПараметры);
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

// Процедура обработчик оповещения "ВыборПериодаПоДатамЗавершение".
//
// Параметры:
// ПериодРезультат	- СтандартныйПериод.
// ДопПараметры 	- Структура.
//
&НаКлиенте
Процедура ВыборПериодаПоДатамЗавершение(ПериодРезультат, ДопПараметры) Экспорт

	Если ПериодРезультат <> Неопределено Тогда
	
		ДопПараметры.Контейнер.ДатаНачала    = ПериодРезультат.ДатаНачала;
		ДопПараметры.Контейнер.ДатаОкончания = ПериодРезультат.ДатаОкончания;		
		
	КонецЕсли; 
	
	ПостроитьОтображениеПериода(ИнтервалыОтчета, Сценарии);
	
КонецПроцедуры	// ВыборПериодаПоДатамЗавершение

#КонецОбласти

