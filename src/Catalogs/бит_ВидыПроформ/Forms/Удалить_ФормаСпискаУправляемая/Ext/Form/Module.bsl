
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.СписокПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма);
	
	// Определение назначения проформы	
	Если Параметры.Свойство("Назначение") Тогда
	
		Назначение = Перечисления.бит_НазначенияПроформ[Параметры.Назначение];
		
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(Назначение) Тогда
	
		Назначение = Перечисления.бит_НазначенияПроформ.ФормаСбораДанных;
	
	КонецЕсли; 	
	
	Если ЗначениеЗаполнено(Назначение) Тогда
		
		
	Иначе	
		
		ТекстСообщения =  НСтр("ru = 'Данная форма не предназначена для непосредственного использования.'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		Отказ = Истина;
		
	КонецЕсли; 
	
	// Проверка лицензии
	бит_ОбщегоНазначения.ПроверитьДоступностьПроформ(Назначение, Отказ);	
	
	// Настройка формы в зависимости от назначения.
	ЭтоФСД = ?(Назначение = Перечисления.бит_НазначенияПроформ.ПроизвольнаяФорма, Ложь, Истина);
	
	Если ЭтоФСД Тогда
		
		ЭтаФорма.Заголовок =  НСтр("ru = 'Виды форм сбора данных'");
		
	Иначе	
		
		ЭтаФорма.Заголовок =  НСтр("ru = 'Виды произвольных форм'");
		
	КонецЕсли; 
	
	Элементы.ФормаКомандаВыгрузитьШаблоныЭксель.Видимость = ЭтоФСД;
	
	ТекСсылка = Неопределено;
	Параметры.Свойство("ТекЗначение", ТекСсылка);	
	
	ОбновитьДерево(ТекСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Записан_ВидПроформы" Тогда
		
	     ТекСсылка = ПолучитьТекущуюСсылку();		
		 ОбновитьДерево(ТекСсылка);
	
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПроформы

&НаКлиенте
Процедура ДеревоПроформыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.ДеревоПроформы.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.Ссылка) Тогда
	
		ПоказатьЗначение(,ТекущаяСтрока.Ссылка);
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПроформыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.бит_ВидыПроформ") 
		 И ВыбранноеЗначение.ЭтоГруппа Тогда
		 
		 ТекущаяСтрока = Элементы.ДеревоПроформы.ТекущиеДанные;
		 
		 Если НЕ ТекущаяСтрока = Неопределено Тогда
		 
		 	 ПереместитьВГруппу(ТекущаяСтрока.Ссылка, ВыбранноеЗначение);
		 
		 КонецЕсли; 
	
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыгрузитьШаблоныЭксель(Команда)
	
	МассивСтрок =  Элементы.ДеревоПроформы.ВыделенныеСтроки;
	
	Если МассивСтрок.Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Не выбраны шаблоны для выгрузки!'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		
	Иначе	
		
		ДанныеДляВыгрузки = ПодготовитьДанныеДляВыгрузки(МассивСтрок);
		
		Если ДанныеДляВыгрузки.МассивДанных.Количество() > 0 Тогда
			
			бит_ПроформыКлиентСервер.ВыгрузитьШаблоныПроформ(ДанныеДляВыгрузки);
			
		Иначе
			
			ТекстСообщения = НСтр("ru = 'Нет данных для выгрузки!'");
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновить(Команда)
	
	ТекСсылка = ПолучитьТекущуюСсылку();
	ОбновитьДерево(ТекСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаРедактировать(Команда)
	
	ТекущаяСтрока = Элементы.ДеревоПроформы.ТекущиеДанные;
	
	Если НЕ ТекущаяСтрока = Неопределено И ЗначениеЗаполнено(ТекущаяСтрока.Ссылка) Тогда
	
		ПоказатьЗначение(,ТекущаяСтрока.Ссылка);
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПометкаУдаления(Команда)
	
	ТекущаяСтрока = Элементы.ДеревоПроформы.ТекущиеДанные;
	
	Если НЕ ТекущаяСтрока = Неопределено Тогда
	
		УстановитьСнятьПометку(ТекущаяСтрока.ПолучитьИдентификатор());
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСоздатьЭлемент(Команда)
	
	ТекущаяСтрока = Элементы.ДеревоПроформы.ТекущиеДанные;
	
	Если НЕ ТекущаяСтрока = Неопределено И ТекущаяСтрока.ЭтоГруппа Тогда
		
		ТекРодитель = ТекущаяСтрока.Ссылка;
		
	КонецЕсли; 
	
	ТекЗначенияЗаполнения = Новый Структура;
	ТекЗначенияЗаполнения.Вставить("Назначение", Назначение);
	ТекЗначенияЗаполнения.Вставить("Родитель", ТекРодитель);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ТекЗначенияЗаполнения);
	ПараметрыФормы.Вставить("ЭтоГруппа", Ложь);
	
	ОткрытьФорму("Справочник.бит_ВидыПроформ.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСоздатьГруппу(Команда)
	
	ТекущаяСтрока = Элементы.ДеревоПроформы.ТекущиеДанные;
	
	Если НЕ ТекущаяСтрока = Неопределено И ТекущаяСтрока.ЭтоГруппа Тогда
	
		ТекРодитель = ТекущаяСтрока.Ссылка;
	
	КонецЕсли; 
	
	ТекЗначенияЗаполнения = Новый Структура;
	ТекЗначенияЗаполнения.Вставить("Назначение", Назначение);
	ТекЗначенияЗаполнения.Вставить("Родитель", ТекРодитель);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ТекЗначенияЗаполнения);
	ПараметрыФормы.Вставить("ЭтоГруппа", Истина);
	
	ОткрытьФорму("Справочник.бит_ВидыПроформ.Форма.ФормаГруппы", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСкопировать(Команда)
	
	ТекущаяСтрока = Элементы.ДеревоПроформы.ТекущиеДанные;
	
	Если НЕ ТекущаяСтрока = Неопределено  Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЭтоГруппа", ТекущаяСтрока.ЭтоГруппа);
		ПараметрыФормы.Вставить("ЗначениеКопирования", ТекущаяСтрока.Ссылка);
		
		Если ТекущаяСтрока.ЭтоГруппа Тогда
			ОткрытьФорму("Справочник.бит_ВидыПроформ.ФормаГруппы", ПараметрыФормы, ЭтаФорма);
		Иначе	
			ОткрытьФорму("Справочник.бит_ВидыПроформ.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПереместитьВГруппу(Команда)
	
	ТекущаяСтрока = Элементы.ДеревоПроформы.ТекущиеДанные;
	
	Если НЕ ТекущаяСтрока = Неопределено  Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Назначение",  Назначение);
		ПараметрыФормы.Вставить("ТекЗначение", ТекущаяСтрока.Ссылка);
		
		ОткрытьФорму("Справочник.бит_ВидыПроформ.ФормаВыбораГруппы", ПараметрыФормы, Элементы.ДеревоПроформы,,,,,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция формирует структуру данных, необходимых для выгрузки шаблонов проформ.
// 
// Параметры:
//  МассивСтрок - Массив
// 
// Возвращаемое значение:
//  ДанныеДляВыгрузки - Структура.
// 
&НаСервере
Функция ПодготовитьДанныеДляВыгрузки(МассивИд)
	
	МассивСтрок = Новый Массив;
	
	Для каждого Ид Из МассивИД Цикл
	
		ТекСтрока = ДеревоПроформы.НайтиПоИдентификатору(Ид);
		
		Если НЕ ТекСтрока = Неопределено Тогда
		
			МассивСтрок.Добавить(ТекСтрока);
		
		КонецЕсли; 
	
	КонецЦикла; 
	
	МассивВидовПроформ = Новый Массив;
	
	Для каждого СтрокаСписка Из МассивСтрок Цикл
		
		Если СтрокаСписка.ЭтоГруппа Тогда
		
			Продолжить;
		
		КонецЕсли; 
		
		МассивВидовПроформ.Добавить(СтрокаСписка.Ссылка);
	
	КонецЦикла; 
	
	ДанныеДляВыгрузки = Справочники.бит_ВидыПроформ.ПодготовитьДанныеДляВыгрузкиШаблона(МассивВидовПроформ);
	
	Возврат ДанныеДляВыгрузки;
	
КонецФункции // ПодготовитьДанныеДляВыгрузки()

// Процедура выполняет обновление дерева видов проформ.
// 
&НаСервере
Процедура ОбновитьДерево(ТекСсылка = Неопределено)

	ДеревоПроформы.ПолучитьЭлементы().Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Назначение", Назначение);
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	бит_ВидыПроформ.Ссылка КАК Ссылка,
	               |	бит_ВидыПроформ.Имя,
	               |	бит_ВидыПроформ.Код,
	               |	бит_ВидыПроформ.Наименование,
	               |	бит_ВидыПроформ.ЭтоГруппа,
	               |	бит_ВидыПроформ.ПометкаУдаления
	               |ИЗ
	               |	Справочник.бит_ВидыПроформ КАК бит_ВидыПроформ
	               |ГДЕ
	               |	бит_ВидыПроформ.Назначение = &Назначение
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Ссылка ИЕРАРХИЯ
	               |АВТОУПОРЯДОЧИВАНИЕ";

	Результат = Запрос.Выполнить();
	
	ДеревоДанные = Результат.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	ДеревоДанные.Колонки.Добавить("Картинка");
	
	ЗначениеВДанныеФормы(ДеревоДанные, ДеревоПроформы);
	
	// Дозаполнение дерева 
	ИдТекущейСтроки = 0;
	ОбойтиДанныеФормыДерево(ДеревоПроформы, ТекСсылка, ИдТекущейСтроки);
	
	// Восстановление позиции в дереве
	Если ИдТекущейСтроки <> 0  Тогда
		
		Элементы.ДеревоПроформы.ТекущаяСтрока = ИдТекущейСтроки;
	
	КонецЕсли; 
	
КонецПроцедуры // ОбновитьДерево()

// Процедура рекурсивно обходит дерево видов проформ и дозаполняет данные. 
// 
&НаСервере
Процедура ОбойтиДанныеФормыДерево(СтрокаВерх, ТекСсылка, ИдТекущейСтроки)

	ТекКоллекция = СтрокаВерх.ПолучитьЭлементы();
	
	Для каждого СтрокаДерева Из ТекКоллекция Цикл
	
		Если СтрокаДерева.ЭтоГруппа Тогда
			
			Если СтрокаДерева.ПометкаУдаления Тогда
				
				СтрокаДерева.Картинка = БиблиотекаКартинок.бит_казна_ПапкаПометка;
				
			Иначе
				
				СтрокаДерева.Картинка = БиблиотекаКартинок.бит_казна_Папка;
			
			КонецЕсли; 
			
		Иначе	
			
			Если СтрокаДерева.ПометкаУдаления Тогда
				
				СтрокаДерева.Картинка = БиблиотекаКартинок.бит_казна_ЕстьЗначениеПометка;
				
			Иначе
				
				СтрокаДерева.Картинка = БиблиотекаКартинок.бит_Реквизит;
			
			КонецЕсли; 
			
		КонецЕсли; 
		
		Если СтрокаДерева.Ссылка = ТекСсылка Тогда
		
			 ИдТекущейСтроки = СтрокаДерева.ПолучитьИдентификатор();
		
		КонецЕсли; 
		
		ОбойтиДанныеФормыДерево(СтрокаДерева, ТекСсылка, ИдТекущейСтроки);
		
	КонецЦикла; 

КонецПроцедуры // ОбойтиДанныеФормыДерево()

// Процедура изменяет пометку удаления у элемента/группы отображаемых в текущей строке. 
// 
// Параметры:
//  ИдСтроки - Число.
// 
&НаСервере
Процедура УстановитьСнятьПометку(ИдСтроки)
	
	ТекСтрока = ДеревоПроформы.НайтиПоИдентификатору(ИдСтроки);
	
	Если НЕ ТекСтрока = Неопределено Тогда
		
		ТекОб = ТекСтрока.Ссылка.ПолучитьОбъект();
		
		Попытка
			
			ТекОб.УстановитьПометкуУдаления(НЕ ТекОб.ПометкаУдаления);
			
		Исключение
			
			ТекстСообщения =  НСтр("ru = 'Не удалось установить пометку удаления! Описание ошибки: %1%.'");
			ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, Строка(ОписаниеОшибки()));
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
			
		КонецПопытки;
		
		ОбновитьДерево(ТекСтрока.Ссылка);
		
	КонецЕсли; 
	
КонецПроцедуры // УстановитьСнятьПометку()

// Процедура выполняет перенос элемента/группы в группу.
// 
// Параметры:
//  ИсходнаяСсылка - СправочникСсылка.бит_ВидыПроформ.
//  ГруппаПриемник - СправочникСсылка.бит_ВидыПроформ.
// 
&НаСервере
Процедура ПереместитьВГруппу(ИсходнаяСсылка, ГруппаПриемник)
	
	ТекОб = ИсходнаяСсылка.ПолучитьОбъект();
	
	ТекОб.Родитель = ГруппаПриемник;
	
	флВыполнено = бит_ОбщегоНазначения.ЗаписатьСправочник(ТекОб,"","Ошибки");
	
	Если флВыполнено Тогда
	
		ОбновитьДерево(ИсходнаяСсылка);
	
	КонецЕсли; 
	
КонецПроцедуры // ПереместитьВГруппу()

// Функция получает ссылку, на которой позиционирована текущая строка дерева.
// 
// Возвращаемое значение:
//  ТекСсылка - СправочникСсылка.бит_ВидыПроформ.
// 
&НаКлиенте
Функция ПолучитьТекущуюСсылку()

	ТекСсылка = Неопределено;
	
	ТекущаяСтрока = Элементы.ДеревоПроформы.ТекущиеДанные;
	
	Если НЕ ТекущаяСтрока = Неопределено Тогда
	
		ТекСсылка = ТекущаяСтрока.Ссылка;
		
	КонецЕсли; 

	Возврат ТекСсылка;
	
КонецФункции // ПолучитьТекущуюСсылку()

#КонецОбласти
