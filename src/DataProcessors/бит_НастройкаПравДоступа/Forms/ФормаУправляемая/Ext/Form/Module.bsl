
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	МетаданныеОбъекта = Метаданные.Обработки.бит_НастройкаПравДоступа;
	
	// Вызов механизма защиты
	
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьКэшЗначений();
	
	// Восстановление настройки по-умолчанию
    УстановитьЗначенияПоУмолчанию();		
	
	Элементы.УсловиеОтключено.СписокВыбора.Добавить("НеОтключенные","Не отключенные");
	Элементы.УсловиеОтключено.СписокВыбора.Добавить("Отключенные");
	Элементы.УсловиеОтключено.СписокВыбора.Добавить("Все");	
	
	Если НЕ ЗначениеЗаполнено(Объект.УсловиеОтключено) ИЛИ Объект.УсловиеОтключено = "Не отключенные" Тогда
		
		Объект.УсловиеОтключено = "НеОтключенные";
		
	КонецЕсли; 
	
	Для каждого эл Из фИменаДеревьев Цикл
		
		СоздатьКолонкиДерева(эл.Значение, эл.Представление);
		
	КонецЦикла; 
	
    ОбновитьВсеПрава(Объект.СубъектДоступа);	
	
	УправлениеВидимостью();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
 Процедура СубъектДоступаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	 
	бит_РаботаСДиалогамиКлиент.НачалоВыбораСоставного(ЭтаФорма
	                                                   ,Элемент
	                                                   ,Объект
	                                                   ,"СубъектДоступа"
													   ,фКэшЗначений.СписокТиповСубъектДоступа
													   ,СтандартнаяОбработка);
	 
	 
 КонецПроцедуры

&НаКлиенте
Процедура СубъектДоступаОчистка(Элемент, СтандартнаяОбработка)
	
	Элементы.СубъектДоступа.ВыбиратьТип = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СубъектДоступаПриИзменении(Элемент)
	
	СубъектДоступаИзменение();
	РазвернутьДеревья();
	
КонецПроцедуры

&НаКлиенте
Процедура УсловиеОтключеноПриИзменении(Элемент)
	
	УсловиеОтключеноИзменение();
	РазвернутьДеревья();	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОбновить(Команда)
	
	ФлОК = ПроверитьЗаполнение();
	
	Если ФлОК Тогда
		
		ОбновитьВсеПрава(Объект.СубъектДоступа);
		РазвернутьДеревья();
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
	ЗаписатьВсе();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьПоШаблону(Команда)
	
	ПараметрыФормы = Новый Структура;
	Шаблоны = Новый Массив;
	Для каждого ТекСтрока Из Объект.Шаблоны Цикл
	
		Шаблоны.Добавить(ТекСтрока.Шаблон);
	
	КонецЦикла; 
	ПараметрыФормы.Вставить("Шаблоны", Шаблоны);
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнениеПоШаблону",ЭтаФорма);
	ОткрытьФорму("Обработка.бит_НастройкаПравДоступа.Форма.ФормаЗаполненияПоШаблонуУправляемая", ПараметрыФормы, ЭтаФорма,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

// Процедура заполняет форму по шаблону.
// 
&НаКлиенте 
Процедура ЗаполнениеПоШаблону(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		
		 Объект.Шаблоны.Очистить();
		 Для каждого ТекШаблон Из Результат.Шаблоны Цикл
		 
		 	НоваяСтрока = Объект.Шаблоны.Добавить();
			НоваяСтрока.Шаблон = ТекШаблон;
		 
		 КонецЦикла; 
		 
		 ОбновитьВсеПрава(Результат.Шаблоны, Истина);
		 Модифицированность = Истина;
		 РазвернутьДеревья();		 
		 
	КонецЕсли; 
                
КонецПроцедуры // ЗаполнениеПоШаблону

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыИФункцииПоРаботеСНастройками

// Функция создает структуру, хранящую настройки.
// 
// Возвращаемое значение:
//   СтруктураНастроек - Структура.
// 
&НаСервере
Функция УпаковатьНастройкиВСтруктуру()

	СтруктураНастроек = Новый Структура;
	Для каждого Реквизит Из Метаданные.Обработки.бит_НастройкаПравДоступа.Реквизиты Цикл
		СтруктураНастроек.Вставить(Реквизит.Имя, Объект[Реквизит.Имя]);
	КонецЦикла;

	Возврат СтруктураНастроек;
	
КонецФункции // УпаковатьНастройкиВСтруктуру()

// Процедура применяет сохраненну настройки.
// 
// Параметры:
//  ВыбНастройка  - СправочникСсылка.бит_СохраненныеНастройки.
// 
&НаСервере
Процедура ПрименитьНастройки(ВыбНастройка)
	
	Если Не ЗначениеЗаполнено(ВыбНастройка) Тогда	
		Возврат;     		
	КонецЕсли;
	
    СтруктураНастроек = ВыбНастройка.ХранилищеНастроек.Получить();
	
	Если ТипЗнч(СтруктураНастроек) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(Объект, СтруктураНастроек);
	    			
	КонецЕсли;

КонецПроцедуры // ПрименитьНастройки()

// Процедура открывает форму восстановления настроек.
// 
// 
&НаСервере
Процедура УстановитьЗначенияПоУмолчанию()

	// Получим настройку по умолчанию
	НастройкаПоУмолчанию = бит_ОтчетыСервер.НайтиНастройкуПоУмолчаниюДляОбъекта(фКэшЗначений.НастраиваемыйОбъект);
	
	// Установим настройку
	ПрименитьНастройки(НастройкаПоУмолчанию);
      
КонецПроцедуры // УстановитьЗначенияПоУмолчанию()

// Процедура - обработчик события "Нажатие" кнопки "НастройкиСохранить" 
// коммандной панели "ДействияФормы".
// 
&НаКлиенте
Процедура ДействияФормыНастройкиСохранить(Кнопка)
	
	ПараметрыФормы     = Новый Структура;
	СтруктураНастройки = УпаковатьНастройкиВСтруктуру();
	ПараметрыФормы.Вставить("СтруктураНастройки" , СтруктураНастройки);
	ПараметрыФормы.Вставить("ТипНастройки"		 , ПредопределенноеЗначение("Перечисление.бит_ТипыСохраненныхНастроек.Обработки"));
	ПараметрыФормы.Вставить("НастраиваемыйОбъект", фКэшЗначений.НастраиваемыйОбъект);
	
	Оповещение = Новый ОписаниеОповещения("СохранитьНастройки",ЭтаФорма);
	ОткрытьФорму("ХранилищеНастроек.бит_ХранилищеНастроек.ФормаСохранения", ПараметрыФормы, ЭтаФорма,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
											
КонецПроцедуры // ДействияФормыНастройкиСохранить()

// Процедура - обработчик оповещения о закрытии формы сохранения настроек. 
// 
&НаКлиенте
Процедура СохранитьНастройки(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		
		РезНастройка = Результат;
		
	КонецЕсли;
	
КонецПроцедуры // СохранитьНастройки()

// Процедура - обработчик события "Нажатие" кнопки "НастройкиВосстановить" 
// коммандной панели "ДействияФормы".
// 
&НаКлиенте
Процедура ДействияФормыНастройкиВосстановить(Кнопка)
	
	ПараметрыФормы     = Новый Структура;
	ПараметрыФормы.Вставить("ТипНастройки"		 , ПредопределенноеЗначение("Перечисление.бит_ТипыСохраненныхНастроек.Обработки"));
	ПараметрыФормы.Вставить("НастраиваемыйОбъект", фКэшЗначений.НастраиваемыйОбъект);
	
	Оповещение = Новый ОписаниеОповещения("ПрименениеНастроек",ЭтаФорма);
	ОткрытьФорму("ХранилищеНастроек.бит_ХранилищеНастроек.ФормаЗагрузки", ПараметрыФормы, ЭтаФорма,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры // ДействияФормыНастройкиВосстановить()

// Процедура - обработчик оповещения о закрытии формы применения настроек. 
// 
&НаКлиенте 
Процедура ПрименениеНастроек(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда        
		
		ПрименитьНастройки(Результат);
		
	КонецЕсли;		
	
КонецПроцедуры // ПрименениеНастроек

#КонецОбласти

#Область ПроцедурыИФункцииОбщегоНазначения

// Процедура разворачивает все уровни деревьев прав доступа. 
// 
&НаКлиенте
Процедура РазвернутьДеревья()
	
	Для каждого эл ИЗ фИменаДеревьев Цикл
		
		бит_РаботаСДиалогамиКлиент.РазвернутьДеревоПолностью(Элементы[эл.Представление], ЭтаФорма[эл.Представление].ПолучитьЭлементы());
		
	КонецЦикла; 
	
КонецПроцедуры // РазвернутьДеревья()

// Процедура Процедура Обрабатывает изменение флажка в табличном поле>.
//  
&НаКлиенте
Процедура ОбработатьИзмененияФлажков(ТекущаяСтрока,ИменаСобытийПолныйПеречень,ИменаСобытий,ИмяКолонки,ЗаполнятьПоРодителю=Ложь)

	ИменаИзмененныхСобытий = Новый Массив;
	
	МассивСвязанныхРедактирование = Новый Массив;
	Если ИменаСобытийПолныйПеречень.Найти("Создание")<>Неопределено Тогда
		МассивСвязанныхРедактирование.Добавить("Создание");
	КонецЕсли;
	Если ИменаСобытийПолныйПеречень.Найти("Копирование")<>Неопределено Тогда
		МассивСвязанныхРедактирование.Добавить("Копирование");
	КонецЕсли; 
	Если ИменаСобытийПолныйПеречень.Найти("ПометкаНаУдаление")<>Неопределено Тогда
		МассивСвязанныхРедактирование.Добавить("ПометкаНаУдаление");
	КонецЕсли; 
	Если ИменаСобытийПолныйПеречень.Найти("Проведение")<>Неопределено Тогда
		МассивСвязанныхРедактирование.Добавить("Проведение");
	КонецЕсли; 
	Если ИменаСобытийПолныйПеречень.Найти("ОтменаПроведения")<>Неопределено Тогда
		МассивСвязанныхРедактирование.Добавить("ОтменаПроведения");
	КонецЕсли; 	
	Если ИменаСобытийПолныйПеречень.Найти("ПереносВГруппу")<>Неопределено Тогда
		МассивСвязанныхРедактирование.Добавить("ПереносВГруппу");
	КонецЕсли; 
	
	Если НЕ ЗаполнятьПоРодителю Тогда
		ИменаИзмененныхСобытий.Добавить(ИмяКолонки);
		
		Если ИмяКолонки = "ВсеПрава" Тогда
			Для каждого ИмяСобытия Из ИменаСобытий  Цикл
				ТекущаяСтрока[ИмяСобытия] = ТекущаяСтрока[ИмяКолонки];
		        ИменаИзмененныхСобытий.Добавить(ИмяСобытия);				
			КонецЦикла; 
		КонецЕсли; 
		
	Иначе	
		Для каждого ИмяСобытия Из ИменаСобытий Цикл
			ТекРодитель = ТекущаяСтрока.ПолучитьРодителя();
			Если НЕ ТекРодитель = Неопределено Тогда
				
				ТекущаяСтрока[ИмяСобытия] = ТекРодитель[ИмяСобытия];	
				ИменаИзмененныхСобытий.Добавить(ИмяСобытия);							
				
			КонецЕсли; 
		КонецЦикла; 
	КонецЕсли; 
	
	Если ИменаСобытийПолныйПеречень.Найти("Создание") <> Неопределено 
		И Не ТекущаяСтрока.Создание 
		И ТекущаяСтрока.Копирование  Тогда
		ТекущаяСтрока.Копирование = Ложь;
		ИменаИзмененныхСобытий.Добавить("Копирование");			
	КонецЕсли; 
	
	Для каждого СвязанноеСобытие Из МассивСвязанныхРедактирование Цикл
		Если НЕ ТекущаяСтрока.Редактирование 
			И ТекущаяСтрока[СвязанноеСобытие] Тогда
			ТекущаяСтрока[СвязанноеСобытие] = Ложь;
			ИменаИзмененныхСобытий.Добавить(СвязанноеСобытие);				
		КонецЕсли; 
	КонецЦикла; 
	
	ВсеИстина = Истина;
	ВсеЛожь   = Истина;
	Для каждого ИмяСобытия Из ИменаСобытийПолныйПеречень  Цикл
		Если ТекущаяСтрока[ИмяСобытия] Тогда
			ВсеЛожь   = Ложь;
		Иначе	
			ВсеИстина = Ложь;
		КонецЕсли; 
	КонецЦикла; 
	Если ВсеИстина Тогда
		ТекущаяСтрока.ВсеПрава = Истина;
	Иначе
		ТекущаяСтрока.ВсеПрава = Ложь;
	КонецЕсли; 
	ТекущаяСтрока.СтрокаОтредактирована = Истина;
	
	бит_РаботаСКоллекциямиКлиентСервер.УдалитьПовторяющиесяЭлементыМассива(ИменаИзмененныхСобытий);
	Для каждого СтрокаДерева Из ТекущаяСтрока.ПолучитьЭлементы() Цикл
		ОбработатьИзмененияФлажков(СтрокаДерева,ИменаСобытийПолныйПеречень,ИменаИзмененныхСобытий,ИмяКолонки,Истина);
	КонецЦикла; 
	
КонецПроцедуры // бит_ОбработатьИзмененияФлажков()

// Процедура-обработчик изменения флагов в деревьях. Назначается программно. 
// 
&НаКлиенте
Процедура ДеревоСправочникиФлагПриИзменении(Элемент)
	
	НомерРазделителя = Найти(Элемент.Имя,"_");
	Если НомерРазделителя > 0 Тогда
		
		ИмяДерева = Лев(Элемент.Имя, НомерРазделителя-1);
		ИмяПоля   = Сред(Элемент.Имя, НомерРазделителя+1);
		
		ТекущаяСтрока = Элементы[ИмяДерева].ТекущиеДанные;
		
		ИменаСобытий = фКэшЗначений.ПолныйПереченьСобытий[ИмяДерева];
		ОбработатьИзмененияФлажков(ТекущаяСтрока, ИменаСобытий, ИменаСобытий, ИмяПоля);
		
	КонецЕсли; 
	
КонецПроцедуры
 
#КонецОбласти

#Область ПрочиеСерверныеПроцедурыИФункции

// Процедура кэширует значения, необходимые для работы на клиенте. 
// 
&НаСервере
Процедура ЗаполнитьКэшЗначений()
	
	фКэшЗначений = Новый Структура;
	фКэшЗначений.Вставить("НастраиваемыйОбъект", "Обработка.бит_НастройкаПравДоступа");
	
	// Заполним список типов для быстрого выбора составного.
	МассивТипов  = Метаданные.Обработки.бит_НастройкаПравДоступа.Реквизиты.СубъектДоступа.Тип.Типы();
	СписокВыбора = бит_ОбщегоНазначения.ПодготовитьСписокВыбораТипа(МассивТипов);
	фКэшЗначений.Вставить("СписокТиповСубъектДоступа", СписокВыбора);
	
	фИменаДеревьев.Добавить(Перечисления.бит_ВидыОбъектовСистемы.Справочник     ,"ДеревоСправочники");
	фИменаДеревьев.Добавить(Перечисления.бит_ВидыОбъектовСистемы.Документ       ,"ДеревоДокументы");
	фИменаДеревьев.Добавить(Перечисления.бит_ВидыОбъектовСистемы.Отчет          ,"ДеревоОтчеты");
	фИменаДеревьев.Добавить(Перечисления.бит_ВидыОбъектовСистемы.Обработка      ,"ДеревоОбработки");
	фИменаДеревьев.Добавить(Перечисления.бит_ВидыОбъектовСистемы.РегистрСведений,"ДеревоРегистрыСведений");
	
	ПолныйПереченьСобытий = Новый Структура;
	Для каждого эл Из фИменаДеревьев Цикл
		
		События = Обработки.бит_НастройкаПравДоступа.ПолучитьИменаСобытий(эл.Значение);
		ПолныйПереченьСобытий.Вставить(эл.Представление, События);
		
	КонецЦикла; 
	фКэшЗначений.Вставить("ПолныйПереченьСобытий", ПолныйПереченьСобытий);
	
КонецПроцедуры // ЗаполнитьКэшЗначений()

// Процедура осуществляет управление видимостью/доступностью элементов формы.
// 
&НаСервере
Процедура УправлениеВидимостью()

	МожноУстанавливать = ?(ЗначениеЗаполнено(Объект.СубъектДоступа),Истина,Ложь);
	Для каждого эл Из фИменаДеревьев Цикл
		Элементы[эл.Представление].ТолькоПросмотр = НЕ МожноУстанавливать;
	КонецЦикла; 
	
	Элементы.ФормаКомандаЗаполнитьПоШаблону.Доступность = МожноУстанавливать;
	
КонецПроцедуры // бит_УправлениеВидимостью()

// Функция конструктор, структуры, используемой для передачи параметров элемента управления.
// 
// Возвращаемое значение:
//  НастройкиОтображения - Строка.
// 
&НаСервере
Функция КонструкторСтруктурыОтображения()

	НастройкиОтображения = Новый Структура("ВидПоля
	                                        |, ПроверкаЗаполнения
	                                        |, Ширина
											|, ФиксацияВТаблице
											|, Видимость
											|, ТолькоПросмотр
											|, СобытиеФлагПриИзменении
											|, КнопкаВыбора
											|, КнопкаРегулирования
											|, КнопкаСпискаВыбора
											|, КнопкаОткрытия
											|, КнопкаОчистки");
	

	НастройкиОтображения.Ширина = 0;
	НастройкиОтображения.ФиксацияВТаблице = ФиксацияВТаблице.Нет;
	НастройкиОтображения.Видимость = Истина;
	НастройкиОтображения.ТолькоПросмотр = Ложь;
	НастройкиОтображения.СобытиеФлагПриИзменении = Ложь;
	
	Возврат НастройкиОтображения;
	
КонецФункции // КонструкторСтруктурыОтображения()

// Функция-конструктор структуры, описывающей колонку дерева прав.
// 
// Параметры:
//   Имя - Строка.
//   Синоним - Строка.
//   Тип - ОписаниеТипов.
//   НастройкиОтображения - Структура.
// 
// Возвращаемое значение:
//  ОписаниеКолонки - Структура.
// 
&НаСервере
Функция КонструкторОписанияКолонки(Имя, Синоним = "", Тип, НастройкиОтображения = Неопределено)
	
	ОписаниеКолонки = Новый Структура("Имя, Синоним, Тип, НастройкиОтображения"
	                                   , Имя
									   , Синоним
									   , Тип
									   , НастройкиОтображения);
									   
    Если НЕ ЗначениеЗаполнено(ОписаниеКолонки.Синоним) Тогда
	
		ОписаниеКолонки.Синоним = Имя;
	
	КонецЕсли; 								   
	
	Если ОписаниеКолонки.НастройкиОтображения = Неопределено Тогда
	
		ОписаниеКолонки.НастройкиОтображения = КонструкторСтруктурыОтображения();
		Если Тип.СодержитТип(Тип("Булево")) Тогда
		
			ОписаниеКолонки.НастройкиОтображения.ВидПоля = ВидПоляФормы.ПолеФлажка;
		
		КонецЕсли; 
	
	КонецЕсли; 
	
	Возврат ОписаниеКолонки;
	
КонецФункции // КонструкторОписанияКолонки()

// Функция добавляет поле формы на форму.
// 
// Параметры:
//  Имя - Строка.
//  ПутьКДанным - Строка.
//  НастройкиОтображения - Структура.
//  ЭлементКонтейнер     - ЭлементФормы.
// 
// Возвращаемое значение:
//  ЭУ - ПолеФормы.
// 
&НаСервере
Функция ДобавитьПолеФормы(Имя, ПутьКДанным, НастройкиОтображения, ЭлементКонтейнер = Неопределено)

	ЭУ = Элементы.Добавить(Имя, Тип("ПолеФормы"), ЭлементКонтейнер);
	ЭУ.ПутьКДанным = ПутьКДанным;		
	
	Если НастройкиОтображения.ВидПоля = ВидПоляФормы.ПолеФлажка Тогда
		
		ЭУ.Вид = ВидПоляФормы.ПолеФлажка;
		
	Иначе
		
		ЭУ.Вид                       = ВидПоляФормы.ПолеВвода;
		ЭУ.АвтоОтметкаНезаполненного = НастройкиОтображения.ПроверкаЗаполнения;
		ЭУ.Ширина                    = НастройкиОтображения.Ширина;
	    ЭУ.РастягиватьПоГоризонтали  = Ложь;	
		ЭУ.ФиксацияВТаблице          = НастройкиОтображения.ФиксацияВТаблице;
		ЭУ.КнопкаВыбора              = НастройкиОтображения.КнопкаВыбора;
		ЭУ.КнопкаОткрытия            = НастройкиОтображения.КнопкаОткрытия;
		ЭУ.КнопкаРегулирования       = НастройкиОтображения.КнопкаРегулирования;
		ЭУ.КнопкаОчистки             = НастройкиОтображения.КнопкаОчистки;
		
	КонецЕсли; 
	
	ЭУ.ТолькоПросмотр = НастройкиОтображения.ТолькоПросмотр;
	ЭУ.Видимость      = НастройкиОтображения.Видимость;
	
	Если НастройкиОтображения.СобытиеФлагПриИзменении Тогда
	
	   ЭУ.УстановитьДействие("ПриИзменении", "ДеревоСправочникиФлагПриИзменении");
	
	КонецЕсли; 
	
	Возврат ЭУ;
	
КонецФункции // ДобавитьПолеФормы()

// Процедура создает колонки дерева прав и устанавливает условное оформление.
// 
// Параметры:
//  ВидОбъекта - ПеречислениеСсылка.бит_ВидыОбъектов.
//  ИмяДерева - Строка.
// 
&НаСервере
Процедура СоздатьКолонкиДерева(ВидОбъекта, ИмяДерева)

	ТекДерево = ЭтаФорма[ИмяДерева];
	ТекДерево.ПолучитьЭлементы().Очистить();
	
	ТекТабПоле = Элементы[ИмяДерева];
	
	ОписаниеБулево    = Новый ОписаниеТипов("Булево");
	флДоступнаОбласть = ?(ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.Справочник 
	                        ИЛИ ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.Документ, Истина, Ложь);
	
	ОписаниеКолонок = Новый Массив;
	
	// Общие колонки
	ТекОписаниеКолонки = КонструкторОписанияКолонки("ОбъектДоступа","Объект доступа", Новый ОписаниеТипов("СправочникСсылка.бит_ОбъектыСистемы"));
	ТекОписаниеКолонки.НастройкиОтображения.ФиксацияВТаблице = ФиксацияВТаблице.Лево;
	ТекОписаниеКолонки.НастройкиОтображения.ТолькоПросмотр    = Истина;		
	ОписаниеКолонок.Добавить(ТекОписаниеКолонки);
	
	ТекОписаниеКолонки = КонструкторОписанияКолонки("ОбластьДоступа","Область доступа", Новый ОписаниеТипов("СправочникСсылка.бит_ОбластиДоступа"));
	ТекОписаниеКолонки.НастройкиОтображения.Видимость = флДоступнаОбласть;
	ТекОписаниеКолонки.НастройкиОтображения.ТолькоПросмотр    = Истина;		
	ТекОписаниеКолонки.НастройкиОтображения.ФиксацияВТаблице = ФиксацияВТаблице.Лево;	
	ОписаниеКолонок.Добавить(ТекОписаниеКолонки);
	
	ТекОписаниеКолонки = КонструкторОписанияКолонки("ЭтоГруппа","Это группа", ОписаниеБулево);
	ТекОписаниеКолонки.НастройкиОтображения.Видимость = Ложь;
	ОписаниеКолонок.Добавить(ТекОписаниеКолонки);
	
	ТекОписаниеКолонки = КонструкторОписанияКолонки("СтрокаОтредактирована","Отредактировано", ОписаниеБулево);
	ТекОписаниеКолонки.НастройкиОтображения.Видимость = Ложь;	
	ОписаниеКолонок.Добавить(ТекОписаниеКолонки);
	
	ТекОписаниеКолонки = КонструкторОписанияКолонки("Отключено","Отключено", ОписаниеБулево);
	ТекОписаниеКолонки.НастройкиОтображения.Видимость = Ложь;	
	ОписаниеКолонок.Добавить(ТекОписаниеКолонки);	
	
	ТекОписаниеКолонки = КонструкторОписанияКолонки("ВсеПрава","Все", ОписаниеБулево);
	ТекОписаниеКолонки.НастройкиОтображения.СобытиеФлагПриИзменении = Истина;	
	ОписаниеКолонок.Добавить(ТекОписаниеКолонки);
	
	// Колонки, отвечающие событиям
	События = Обработки.бит_НастройкаПравДоступа.ОпределитьСобытия(ВидОбъекта);
	Если НЕ События = Неопределено Тогда
		
		Для каждого ЗначениеПеречисления Из События Цикл
			
			ИмяЗначения = бит_ОбщегоНазначения.ПолучитьИмяЗначенияПеречисления(События,ЗначениеПеречисления);
			
			Если ИмяЗначения = "Печать" Тогда
			
				 Продолжить;
			
			КонецЕсли; 
			
			ТекОписаниеКолонки = КонструкторОписанияКолонки(ИмяЗначения, Строка(ЗначениеПеречисления), ОписаниеБулево);
			ТекОписаниеКолонки.НастройкиОтображения.СобытиеФлагПриИзменении = Истина;
			ОписаниеКолонок.Добавить(ТекОписаниеКолонки);
			
		КонецЦикла; 
		
	КонецЕсли;
	
	// Добавляем реквизиты
	ДобавляемыеРеквизиты = Новый Массив;
	Для каждого ТекОписаниеКолонки Из ОписаниеКолонок Цикл
		
		НовыйРеквизит = Новый РеквизитФормы(ТекОписаниеКолонки.Имя, ТекОписаниеКолонки.Тип, ИмяДерева ,ТекОписаниеКолонки.Синоним, Истина);
		ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
		
	КонецЦикла; 
	
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	// Создаем элементы формы
	Для каждого ТекОписаниеКолонки Из ОписаниеКолонок Цикл
		
		ИмяЭлемента = ИмяДерева+"_"+ТекОписаниеКолонки.Имя;
		ПутьКДанным = ИмяДерева+"."+ТекОписаниеКолонки.Имя;
		ДобавитьПолеФормы(ИмяЭлемента, ПутьКДанным, ТекОписаниеКолонки.НастройкиОтображения, ТекТабПоле); 
		
	КонецЦикла; 

	// Условное оформление
	
	// Группы
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	ЭлементУО.Представление = ИмяДерева;
	ЭлементУО.Использование = Истина;
	
	УсловиеУО 				 = ЭлементУО.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	УсловиеУО.Использование  = Истина;
	УсловиеУО.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ИмяДерева+".ЭтоГруппа");
	УсловиеУО.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	УсловиеУО.ПравоеЗначение = Истина;
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоЖелтыйЗолотистый);	
	
	ОформляемоеПоле 	 = ЭлементУО.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(ИмяДерева);
	
	// Отключенные элементы
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	ЭлементУО.Представление = ИмяДерева;
	ЭлементУО.Использование = Истина;
	
	УсловиеУО 				 = ЭлементУО.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	УсловиеУО.Использование  = Истина;
	УсловиеУО.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ИмяДерева+".Отключено");
	УсловиеУО.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	УсловиеУО.ПравоеЗначение = Истина;
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоСерый);	
	
	ОформляемоеПоле 	 = ЭлементУО.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(ИмяДерева);
	
	// Отредактированные строки
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	ЭлементУО.Представление = ИмяДерева;
	ЭлементУО.Использование = Истина;
	
	УсловиеУО 				 = ЭлементУО.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	УсловиеУО.Использование  = Истина;
	УсловиеУО.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ИмяДерева+".СтрокаОтредактирована");
	УсловиеУО.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	УсловиеУО.ПравоеЗначение = Истина;
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт("Arial",8,Ложь,Истина));	
	
	ОформляемоеПоле 	 = ЭлементУО.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(ИмяДерева);
	
КонецПроцедуры // СоздатьКолонкиДерева()

// Процедура выполняет обновление всех деревьев.
// 
// Параметры:
//  СубъектДоступа - СправочникСсылка.бит_Пользователи
// 					или СправочникСсылка.бит_ШаблоныПравДоступа
//                  или СправочникСсылка.ГруппыПользователей.
// 
&НаСервере
Процедура ОбновитьВсеПрава(СубъектДоступа, СтрокаОтредактирована = Ложь)
	
	Для каждого эл Из фИменаДеревьев Цикл
		
		ОбновитьДеревоПрав(эл.Значение, СубъектДоступа, эл.Представление, СтрокаОтредактирована);
		
	КонецЦикла; 
	
КонецПроцедуры // ОбновитьДеревья()

// Процедура добавляет строки в дерево значений.
// 
// Параметры:
//  ВидОбъекта  - ПеречислениеСсылка.бит_ВидыОбъектовСистемы.
//  ВыборкаВерхняя - ВыборкаИзРезультатаЗапроса.
//  ВерхняяСтрока  - СтрокаДереваЗначений.
//      
&НаСервере
Процедура ДобавитьСтрокиВДерево(ВидОбъекта,ВыборкаВерхняя,ВерхняяСтрока,СтрокаОтредактирована=Ложь)
	
	ИменаСобытий = Обработки.бит_НастройкаПравДоступа.ПолучитьИменаСобытий(ВидОбъекта);
	
	Выборка = ВыборкаВерхняя.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	Пока Выборка.Следующий() Цикл
		
		Если ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.Обработка 
			 ИЛИ ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.Отчет Тогда
			 
			 // Не выводим типовые отчеты и обработки, т.к. механизм на них не действует
			 // из-за того, что подписок на эти виды объектов нет
			 // т.е. без изменения объекта внедрить вызов механизма не получается.
			 
			 Если НЕ Выборка.ОбъектДоступа.ЭтоГруппа Тогда
			 
			 	Если НЕ ВРег(Лев(Выборка.ОбъектДоступа.ИмяОбъекта,4)) = ВРег("бит_") Тогда
				
					 Продолжить;
				
				КонецЕсли; 
			 
			 КонецЕсли; 
		
		КонецЕсли; 
		
		ТекКоллекция = ВерхняяСтрока.ПолучитьЭлементы();
		НоваяСтрока                  = ТекКоллекция.Добавить();
		НоваяСтрока.ОбъектДоступа    = Выборка.ОбъектДоступа;
		НоваяСтрока.ЭтоГруппа        = Выборка.ЭтоГруппа;
		НоваяСтрока.ОбластьДоступа   = Выборка.ОбластьДоступа;
		НоваяСтрока.Отключено 		 = Выборка.Отключено;
		НоваяСтрока.СтрокаОтредактирована = СтрокаОтредактирована;
		ВсеИстина = Истина;
		ВсеЛожь   = Истина;		
		Для каждого ИмяКолонки Из ИменаСобытий Цикл
			НоваяСтрока[ИмяКолонки] = Выборка[ИмяКолонки];
			Если НоваяСтрока[ИмяКолонки] Тогда
				ВсеЛожь = Ложь;
			Иначе
				ВсеИстина = Ложь;
			КонецЕсли; 
		КонецЦикла; 
		Если ВсеИстина Тогда
			НоваяСтрока.ВсеПрава = Истина;
		Иначе
			НоваяСтрока.ВсеПрава = Ложь;
		КонецЕсли; 
		
		ДобавитьСтрокиВДерево(ВидОбъекта,Выборка,НоваяСтрока,СтрокаОтредактирована);
		
	КонецЦикла;
	
КонецПроцедуры // бит_ДобавитьСтрокуВДерево()

 // Процедура обновляет дерево прав доступа. 
 // 
&НаСервере
Процедура ОбновитьДеревоПрав(ВидОбъекта, СубъектДоступа, ИмяДерева,СтрокаОтредактирована=Ложь)
	
	ТекДерево = ЭтаФорма[ИмяДерева];
	ТекДерево.ПолучитьЭлементы().Очистить();
	
	ТекТабПоле = Элементы[ИмяДерева];
	
	Результат = Обработки.бит_НастройкаПравДоступа.СформироватьДеревоПрав(ВидОбъекта,СубъектДоступа, Объект.УсловиеОтключено);
	
	// Табличка = Результат.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	// Табличка.ВыбратьСтроку();
	
	ДобавитьСтрокиВДерево(ВидОбъекта,Результат,ТекДерево,СтрокаОтредактирована);
	ТекТабПоле.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВсеУровни;
	
КонецПроцедуры // ОбновитьУчетнуюПолитику()

 // Процедура обрабатывает изменение субъекта доступа. 
 // 
 &НаСервере
 Процедура СубъектДоступаИзменение()
	 
	ОбновитьВсеПрава(Объект.СубъектДоступа);
 	УправлениеВидимостью();
 
 КонецПроцедуры // СубъектДоступаИзменение()

 // Процедура обрабатывает изменение реквизита "УсловиеОтключено".
 // 
 &НаСервере
 Процедура УсловиеОтключеноИзменение()
 
	ОбновитьВсеПрава(Объект.СубъектДоступа);
 	УправлениеВидимостью();	
 
 КонецПроцедуры // УсловиеОтключеноИзменение()

// Процедура вызывает запись всех отредактированных прав.
// 
&НаСервере
Процедура ЗаписатьВсе()
	
	ОбОбъект = ДанныеФормыВЗначение(Объект, Тип("ОбработкаОбъект.бит_НастройкаПравДоступа"));
	
	Для каждого эл Из фИменаДеревьев Цикл
		
		ОбОбъект.УстановитьЗначения(эл.Значение, ЭтаФорма[эл.Представление]);
		
	КонецЦикла; 
	
	ЭтаФорма.Модифицированность = Ложь;
	
КонецПроцедуры // ЗаписатьВсе()

#КонецОбласти

#КонецОбласти


